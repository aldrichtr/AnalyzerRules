
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Collections.ObjectModel
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function Format-TrapStatement {
  <#
.SYNOPSIS
  Format the `trap` keyword using UPPER, lower, or Capital case.
.INPUTS
  [System.Management.Automation.Language.TrapStatementAst]
.OUTPUTS
  [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
   #>
  [RuleCategory('FormatKeyword')]
  [CmdletBinding()]
  param(
    [Parameter( Mandatory)]
    [TrapStatementAst]$TrapStatementAst
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    $ruleName    = $self | Format-RuleName | Select-Object -ExpandProperty ShortName

    $case        = [StringCase]::None


    # TODO[epic=Debugging]: When run under ScriptAnalyzer, there is no Debug output, so is Write-Debug even helpful here?
    # TODO[epic=Defaults]: If DefaultCase Setting is set then we might not want to break if not configured

    # SECTION Settings

    <# NOTE: Settings process
    Settings can be set for an entire Rule Category, which will act as the defaults for all rules in the category.
    Any settings that are set explicitly on a Rule takes precedence over the category settings.

    Since this rule tests for the case of the keyword to conform with the Case setting, then we abort the rule if we
    cannot determine the Case.
    #>

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
      Write-Debug "There are no settings for rule $ruleName."
    } else {
      #!! There are rule settings
      if (-not ($settings.ContainsKey('Enabled'))) {
        Write-Debug "Rule settings exist, but do not contain 'Enabled'.  Aborting"
        return $null
      } else {
        if ($settings.Enabled -eq $false) {
          Write-Debug 'Rule is explicitly disabled in settings.  Aborting'
          <#! The Rule is not enabled so we return from the function #>
          return $null
        } else {
          Write-Debug 'Rule is explicitly enabled in settings.'
          if ($settings.ContainsKey('Case')) {
            $case = $settings.Case | ConvertTo-StringCaseType
          }
        }
      }
    }
    # !SECTION Explicit Rule Settings

    # !SECTION Settings

    Write-Debug "Format-TrapStatement case set to $case"

    # SECTION Predicate definition
    [scriptblock]$predicate = {
      param($ast)
      $astMatchesPredicate = $false
      if ($ast -is [TrapStatementAst]) {
        $null = $ast.Extent.Text -imatch '(trap)'
        $keyword = ${Matches}?.1
        if ($null -eq $keyword) {
          $astMatchesPredicate = $false
          Write-Debug "Something went wrong, cant find 'trap' keyword in text"
          return $astMatchesPredicate
        }
        $keywordMatchesCase = ($keyword | Test-Case $case.ToString())

        # NOTE: We only want to match on violations, so the filter Should only match on TrapStatementAsts that are
        # not in the right case.
        $astMatchesPredicate = (-not $keywordMatchesCase)
      }
      return $astMatchesPredicate
    }
    # !SECTION


  }
  process {
    # NOTE: One last sanity check before we start the process
    if ($case -eq [StringCase]::None) {
      Write-Debug 'Case was not set, cannot continue'
      return $null
    }

    # SECTION Find violations
    if ($null -eq $predicate ) {
      throw "Predicate scriptblock was not created"
    }

    try {
      $violations = $TrapStatementAst | Select-RuleViolation -Filter $predicate
    } catch {
      throw "There was an error while trying to find violations`n$_"
    }
    # !SECTION

    if ($violations.Count -gt 0) {
      Write-Debug "There were $($violations.Count) violations found"
      $results = New-DiagnosticRecordCollection
    }

    :violation foreach ($violation in $violations) {
      $extent = $violation.Extent
      $text = $extent.Text
      # SECTION Isolate keyword

      $null = $text -imatch '^(trap)(.*)'
      $trapWord = ${Matches}?.1
      $remainingText = ${Matches}?.2

      Write-Debug "Separating keyword '$trapWord' from body '$remainingText'"
      # !SECTION Isolate keyword

      # SECTION Create Correction
      $newCase = $trapWord | Convert-Case $case.ToString()
      $message = "keyword $trapWord should be $($case.ToString())"

      $replacement = ('{0}{1}' -f $newCase, $remainingText)
      Write-Debug "- Correction is: '$replacement'`n  Message: '$message'"

      $correctionOptions = @{
        ReplacementText = $replacement
        Description     = "Set trap keyword to $($case.ToString())"
      }

      $correction = $extent | New-Correction @correctionOptions

      # !SECTION Create Correction

      # SECTION Create Record

      $message = "$message`nThere are $($results.Count) results in the collection"

      $options = @{
        RuleName             = $ruleName
        Extent               = $violation.Extent
        Message              = $message
        SuggestedCorrections = $correction
      }

      try {
        $record = New-DiagnosticRecord @options
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
    Write-Debug "There were $($results.Count) violations of $ruleName"
    return $results
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
