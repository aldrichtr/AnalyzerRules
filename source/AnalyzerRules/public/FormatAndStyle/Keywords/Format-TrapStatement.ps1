
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Collections.ObjectModel
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function Format-TrapStatement {
  <#
.SYNOPSIS
  Ensure the `trap` keyword in in the case given in `FormatTrapStatement` setting.
.DESCRIPTION
  Format the `trap` keyword using UPPER, lower, or Capital case, according to the `Case` setting. This rule is part of the `FormatKeyword` category.
  Settings for `FormatTrapStatement` and `FormatKeyword` are both evaluated.
  See details in the docs under *Settings that affect rules*
 .INPUTS
  [System.Management.Automation.Language.TrapStatementAst]
.OUTPUTS
  [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
   #>
  [RuleCategory('FormatKeyword')]
  [CmdletBinding()]
  param(
    [Parameter( Mandatory)]
    [TrapStatementAst]$InputAst
  )
  begin {
    $self           = $MyInvocation.MyCommand
    $ruleName       = $self | Format-RuleName | Select-Object -ExpandProperty ShortName
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
    if ($null -eq $settings) {
    } else {
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
      param($ast)

      $doesAstMatchPredicate = $false
      $doesKeywordMatchCase  = $false

      if ($ast -is [TrapStatementAst]) {
        $null = $ast.Extent.Text -imatch $keywordPattern
        $keyword = ${Matches}?.1
        $doesAstMatchPredicate = ($null -ne $keyword)
        $doesKeywordMatchCase = ($keyword | Test-Case $case.ToString())

        # NOTE: We only want to match on violations, so the filter Should only match on TrapStatementAsts that are
        # not in the right case.
        $doesAstMatchPredicate = (-not $doesKeywordMatchCase)
      }
      return $doesAstMatchPredicate
    }
    # !SECTION


  }
  process {
    # NOTE: One last sanity check before we start the process
    if ($case -eq [StringCase]::None) {
      return $null
    }

    # SECTION Find violations

    try {
      $violations = $InputAst | Select-RuleViolation $predicate
    } catch {
      throw "There was an error while trying to find violations`n$_"
    }
    # !SECTION

    if ($violations.Count -gt 0) {
      $results = New-DiagnosticRecordCollection
    }

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
  end {
    return $results
  }
}
