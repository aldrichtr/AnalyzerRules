
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-TrapStatement {
    <#
    .SYNOPSIS
        Format the `trap` keyword using Upper, Lower, or Capitalize case.
    #>
    [CmdletBinding()]
    [OutputType([DiagnosticRecord[]])]
    param(
      [Parameter(
        Mandatory
      )]
      [TrapStatementAst]$TrapStatementAst
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
      $DEFAULT_CASE = 'lower'

        $ruleName = (Format-RuleName)
        $results = New-DiagnosticRecordCollection
        $corrections = New-CorrectionCollection
        $ruleArgs = Get-RuleSetting

        # TODO(Defaults): If DefaultCase Setting is set then we might not want to break if not configured
        #! break early if this rule is not configured or explicitly disabled
        if (($null -eq $ruleArgs) -or (-not ($ruleArgs.Enabled))) { return $null }

        if ($null -eq $ruleArgs.Case) {
            $ruleArgs.Case = $DEFAULT_BLOCK_CASE
        }

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

        $predicate = {
            param(
                [Parameter()]
                [Ast]$Ast
            )
            $text = $Ast.Extent.Text
            if (($Ast -is [TrapStatementAst]) -and
             ($text -imatch '^trap')) {
                switch ($case) {
                    ([StringCase]::Lower) { $text | Test-Case lower }
                    ([StringCase]::Upper) { $text | Test-Case upper }
                    ([StringCase]::Capital) { $text | Test-Case capital }
                }
            }
        }
    }
    process {
        try {
            $violations = $TrapStatementAst | Select-RuleViolation $predicate
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
                        $message = "trap keyword $text should be lowercase"
                    }
                    ([StringCase]::Upper) {
                        $newText = $text | Convert-Case upper
                        $newExtent = $extent
                        | New-Correction -Replacement ($newText)
                        $message = "trap keyword $text should be uppercase"
                    }
                    ([StringCase]::Capital) {
                        $newText = $text | Convert-Case capital
                        $newExtent = $extent
                        | New-Correction -Replacement ($newText)
                        $message = "trap keyword $text should be uppercase"
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
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
    end {
        $results
    }
}
