
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Collections.ObjectModel
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function Format-TrapStatement {
  <#
.SYNOPSIS
  Ensure the `trap` keyword is the case given in the `FormatTrapStatement` setting.
.DESCRIPTION
  Format the `trap` keyword using UPPER, lower, or Capital case, according to the `Case` setting. This rule
  is part of the `FormatKeyword` category.  Settings for `FormatTrapStatement` and `FormatKeyword` are both
  evaluated.  See details in the docs under *Settings that affect rules*
 .INPUTS
  [System.Management.Automation.Language.TrapStatementAst]
.OUTPUTS
  [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
   #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatExceptionHandlers')]
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory,
      ValueFromPipeline
    )]
    [TrapStatementAst]$InputAst
  )
  begin {
    $self           = $MyInvocation.MyCommand
    $ruleName       = $self | Select-RuleName
    $keywordPattern = '(trap)'
    $case           = [StringCase]::None

    # SECTION Settings

    # SECTION Category Settings
    $category = Get-RuleCategory $self.Name
    if ($null -ne $category) {
      $catSettings = $category.Settings()
      if ($null -ne ${catSettings}?.Case) {
        $case = $catSettings.Case | ConvertTo-StringCaseType
      }
    }
    # !SECTION Category Settings


    # SECTION Explicit Rule Settings
    $settings    = Get-RuleSetting $ruleName
    if ($null -ne $settings) {
      #!! There are rule settings
      if (-not ($settings.ContainsKey('Enabled'))) {
        return $null
      } else {
        if ($settings.Enabled -eq $false) {
          <#! The Rule is not enabled so we return from the function #>
          return $null
        } else {
          if ($settings.ContainsKey('Case')) {
            $case = $settings.Case | ConvertTo-StringCaseType
          }
        }
      }
    }
    # !SECTION Explicit Rule Settings

    # !SECTION Settings


    # SECTION Predicate definition
    [scriptblock]$predicate = {
      param([Parameter()][Ast]$Ast)

      $isViolation = $isKeywordPresent = $doesKeywordMatchCase = $false

      if ($Ast -is [TrapStatementAst]) {
        $null = $Ast.Extent.Text -imatch $keywordPattern
        $keyword = ${Matches}?.1
        $isKeywordPresent = ($null -ne $keyword)
        if ($isKeywordPresent) {
          $doesKeywordMatchCase = ($keyword | Test-Case $case.ToString())
          if ($doesKeywordMatchCase) {
            $isViolation = $false
          } else {
            $isViolation = $true
          }
        } else {
          $isViolation = $false
        }

      }
      return $isViolation
    }
    # !SECTION


  } process {

    # SECTION Find violations

    try {
      $violations = $InputAst | Select-RuleViolation $predicate
    } catch {
      throw "There was an error while trying to find violations`n$_"
    }
    # !SECTION

    $results = $null
    if ($violations.Count -gt 0) {
      $results = New-DiagnosticRecordCollection


      :violation foreach ($violation in $violations) {
        $extent = $violation.Extent
        $text = $extent.Text
        # SECTION Isolate keyword

        $null = $text -imatch "^$keywordPattern(.*)"
        $keyword = ${Matches}?.1
        $remainingText = ${Matches}?.2

        # !SECTION Isolate keyword

        # SECTION Create Correction
        $correctedKeyword = $keyword | Convert-Case $case.ToString()
        $message = "keyword $keyword should be $($case.ToString())"

        $replacement = ('{0}{1}' -f $correctedKeyword, $remainingText)

        $correctionOptions = @{
          ReplacementText = $replacement
          Description     = "Set keyword to $($case.ToString())"
        }

        $correction = $extent | New-Correction @correctionOptions

        # !SECTION Create Correction

        # SECTION Create Record
        $recordOptions = @{
          RuleName             = $ruleName
          Severity             = [RuleSeverity]::Warning
          Extent               = $violation.Extent
          Message              = $message
          SuggestedCorrections = $correction
        }

        try {
          $record = New-DiagnosticRecord @recordOptions
        } catch {
          throw "There was an error creating the results`n$_"
        }
        if ($null -ne $record) {
          [void]$results.Add($record)
          # Clear result after adding it to collection
          $record = $null
        } else {
          throw 'Failed to create a result record'
        }
        # !SECTION
      }
    }
  } end {
    return $results
  }
}
