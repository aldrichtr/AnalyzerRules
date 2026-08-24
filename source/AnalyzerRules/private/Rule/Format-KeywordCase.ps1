
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-KeywordCase {
  <#
  .SYNOPSIS
    Common engine for keyword-case format rules.
  .DESCRIPTION
    Handles settings resolution, predicate construction, violation detection,
    correction generation, and DiagnosticRecord creation for any rule that enforces
    a specific case on a keyword token.

    Public Format-* rules delegate to this function, passing a KeywordMap that maps
    regex patterns to category attribute names. This allows a single function (bound
    to one AST class) to handle keywords that belong to different settings categories.

    Settings resolution per keyword:
      1. Check the specific category setting (e.g. FormatParameterKeyword)
      2. Fall back to FormatKeywords (the top-level parent)
      3. Check explicit rule-level settings (override everything)
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSReviewUnusedParameter', 'AstType',
    Justification = 'AstType is captured by the predicate scriptblock closure'
  )]
  [CmdletBinding()]
  param(
    # The AST node handed to the public rule by PSSA
    [Parameter(Mandatory)]
    [Ast]$InputAst,

    # The expected AST type to match in the predicate (e.g. [NamedBlockAst])
    [Parameter(Mandatory)]
    [type]$AstType,

    # A hashtable mapping keyword regex patterns to their category attribute name.
    # e.g. @{ '^(begin|process|end|clean)' = 'FormatNamedBlock'; '^(dynamicparam)' = 'FormatParameterKeyword' }
    [Parameter(Mandatory)]
    [hashtable]$KeywordMap,

    # The calling command info ($MyInvocation.MyCommand from the public function)
    [Parameter(Mandatory)]
    [System.Management.Automation.CommandInfo]$CallerCommand
  )

  $ruleName = $CallerCommand | Select-ShortName

  # -- Pre-resolve case settings for each category in the KeywordMap --
  # Build a lookup: pattern -> resolved [StringCase]
  $patternCaseMap = @{}
  $allPatterns = @($KeywordMap.Keys)

  foreach ($pattern in $allPatterns) {
    $categoryName = $KeywordMap[$pattern]
    $case = [StringCase]::None

    # Top-level FormatKeywords fallback
    $topLevel = Get-RuleSetting 'FormatKeywords'
    if ($null -ne ${topLevel}?.Case) {
      $case = $topLevel.Case | ConvertTo-StringCaseType
    }

    # Specific category setting (e.g. FormatNamedBlock)
    $catSettings = Get-RuleSetting $categoryName
    if ($null -ne $catSettings) {
      if ($catSettings.ContainsKey('Enabled') -and $catSettings.Enabled -eq $false) {
        $case = [StringCase]::None
      } elseif ($null -ne ${catSettings}?.Case) {
        $case = $catSettings.Case | ConvertTo-StringCaseType
      }
    }

    # Explicit rule-level settings (highest priority)
    $ruleSettings = Get-RuleSetting $ruleName
    if ($null -ne $ruleSettings) {
      if (-not $ruleSettings.ContainsKey('Enabled') -or $ruleSettings.Enabled -eq $false) {
        $case = [StringCase]::None
      } elseif ($ruleSettings.ContainsKey('Case')) {
        $case = $ruleSettings.Case | ConvertTo-StringCaseType
      }
    }

    $patternCaseMap[$pattern] = $case
  }

  # If all resolved cases are None, nothing to enforce
  $hasEnforcement = $false
  foreach ($c in $patternCaseMap.Values) {
    if ($c -ne [StringCase]::None) { $hasEnforcement = $true; break }
  }
  if (-not $hasEnforcement) { return $null }

  # -- Build predicate (close over $AstType, $allPatterns, $patternCaseMap) --
  [scriptblock]$predicate = {
    param([Ast]$Ast)
    if ($Ast -isnot $AstType) { return $false }

    foreach ($pattern in $allPatterns) {
      $null = $Ast.Extent.Text -imatch $pattern
      $kw = ${Matches}?.1
      if ($null -ne $kw) {
        $case = $patternCaseMap[$pattern]
        if ($case -eq [StringCase]::None) { return $false }
        return -not ($kw | Test-Case $case.ToString())
      }
    }
    return $false
  }.GetNewClosure()

  # -- Find violations --
  try {
    $violations = $InputAst | Select-RuleViolation -Filter $predicate
  } catch {
    throw "Error finding violations for rule '$ruleName': $_"
  }

  if ($violations.Count -eq 0) { return $null }

  # -- Build diagnostic records --
  $results = New-DiagnosticRecordCollection

  foreach ($violation in $violations) {
    $extent = $violation.Extent

    # Determine which pattern matched and get resolved case for correction
    $keyword = $null
    $remainingText = $null
    $case = [StringCase]::None

    foreach ($pattern in $allPatterns) {
      $null = $extent.Text -imatch "^${pattern}(.*)"
      $kw = ${Matches}?.1
      if ($null -ne $kw) {
        $keyword = $kw
        $remainingText = ${Matches}?.2
        $case = $patternCaseMap[$pattern]
        break
      }
    }

    if ($null -eq $keyword -or $case -eq [StringCase]::None) { continue }

    $correctedKeyword = $keyword | Convert-Case $case.ToString()
    $replacement      = '{0}{1}' -f $correctedKeyword, $remainingText

    $correctionOptions = @{
      ReplacementText = $replacement
      Description     = "Set keyword to $($case.ToString())"
    }

    $correction = $extent | New-Correction @correctionOptions

    $recordOptions = @{
      RuleName             = $ruleName
      Extent               = $extent
      Message              = "keyword '$keyword' should be $($case.ToString())"
      SuggestedCorrections = $correction
    }

    $record = New-DiagnosticRecord @recordOptions

    [void]$results.Add($record)
  }

  return $results
}
