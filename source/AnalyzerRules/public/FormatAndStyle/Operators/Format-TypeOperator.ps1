
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-TypeOperator {
  <#
    .SYNOPSIS
        Test and optionally fix the format of Type Operators
    #>
  [CmdletBinding()]
  [OutputType([DiagnosticRecord[]])]
  param(
    [Parameter( Mandatory)]
    [CommandAst]$CommandAst
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    $DEFAULT_CASE = [StringCase]::Lower

    $ruleName    = $self | Format-RuleName | Select-Object -ExpandProperty ShortName

    $results     = New-DiagnosticRecordCollection
    $corrections = New-CorrectionCollection
    $ruleArgs    = Get-RuleSetting $ruleName

    # TODO(Defaults): If DefaultCase Setting is set then we might not want to break if not configured
    #! break early if this rule is explicitly disabled
    if ($null -ne $ruleArgs) {
      if (($ruleArgs.ContainsKey('Enabled')) -and
        ($ruleArgs.Enabled -eq $false)) {
        Write-Debug 'Rule is disabled in settings'
        <#! The Rule is not enabled so we return from the function #>
        return $null
      } else {
        # rule is enabled
        if ($ruleArgs.ContainsKey('Case')) {
          # case insensitive by default, so the settings can be 'lower', 'Lower', etc.
          switch -Regex ($ruleArgs.Case) {
            '^low' { $case = [StringCase]::Lower }
            '^up' { $case = [StringCase]::Upper }
            '^cap' { $case = [StringCase]::Capital }
            default {
              Write-Verbose "'$($ruleArgs.Case)' is not a valid setting.  Use 'lower', 'upper', or 'capital'"
              return $null
            }
          }
        }
      }
    } else {
      Write-Debug "No Settings for $ruleName"
      $case = $DEFAULT_CASE
    }

    Write-Debug "$(self.Name) case set to $case"

}
process {
  try {
      $violations = $TrapStatementAst | Select-RuleViolation -Filter {
        param(
          [Parameter()][Ast]$Ast
        )
        $text = $Ast.Extent.Text
        Write-Debug "Received AST $($Ast.GetType().FullName):"
        Write-Debug "- with Text '$text'"
        if (($Ast -is [CommandAst]) -and

        ($text -imatch '-(is(not)?|as)')) {
            Write-Debug "Validating case of '$text'"
          switch ($case) {
            ([StringCase]::Lower) {
              return ($text | Test-Case lower)
            }
            ([StringCase]::Upper) {
              return ($text | Test-Case upper)
             }
            ([StringCase]::Capital) {
              return ($text | Test-Case capital) }
          }
        }
      }

      :violation foreach ($violation in $violations) {
        $extent = $violation.Extent
        $text = $extent.Text
        $options = @{
          Severity = 'Warning'
          Extent   = $extent
        }

        :case switch ($case) {
          ([StringCase]::Lower) {
            $newText = $text | Convert-Case lower
            $newExtent = $extent
            | New-Correction -Replacement ($newText)
            $message = "Type Operator $text should be lowercase"
          }
          ([StringCase]::Upper) {
            $newText = $text | Convert-Case upper
            $newExtent = $extent
            | New-Correction -Replacement ($newText)
            $message = "Type Operator $text should be uppercase"
          }
          ([StringCase]::Capital) {
            $newText = $text | Convert-Case capital
            $newExtent = $extent
            | New-Correction -Replacement ($newText)
            $message = "Type Operator $text should be uppercase"
          }
        }
        [void]$corrections.Add($newExtent)

        $options = @{
          RuleName             = $ruleName
          SuppressionId        = $ruleName
          Severity             = 'Warning'
          Extent               = $extent
          Message              = $message
          SuggestedCorrections = $corrections
        }

        [void]$results.Add((New-DiagnosticRecord @options))
      }
      return $results
  }
  catch {
    $PSCmdlet.ThrowTerminatingError($PSItem)
  }

}
end {
  Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
}
}
