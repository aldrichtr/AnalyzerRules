
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-TryBlock {
    <#
    .SYNOPSIS
        Ensure Try/Catch script blocks are in the case given in the FormatTryBlock setting.
    .DESCRIPTION
        The try blocks in the file are `try`, `catch`, and `finally`.  There are three types of 'case'
        settings that can be configured in the Settings file under FormatTryBlock, `lower`, `upper`, `capital`
        ```powershell
        Rules = @{
            FormatTryBlock = @{
                Enabled = $true
                Case = 'lower'
            }
        }
        ```
    #>
    [RuleCategory("FormatKeyword")]
    [CmdletBinding()]
    [OutputType([DiagnosticRecord[]])]
    param(
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [TryBlockAst]$TryBlockAst
    )
    begin {
        #TODO(Defaults): Add a DefaultCase Setting somewhere appropriate

        $ruleName = (Format-RuleName)



        $predicate = {
            param(
                [Parameter()]
                [Ast]$Ast
            )
            $text = $Ast.Extent.Text
            if ($Ast -is [TryStatementAst]) {
              <#TODO: test case#>return $true
            }
        }
    }
    process {
        try {
            $violations = $TryBlockAst | Select-RuleViolation $predicate
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
                        $message = "Try block keyword $text should be lowercase"
                    }
                    ([StringCase]::Upper) {
                        $newText = $text | Convert-Case upper
                        $newExtent = $extent
                        | New-Correction -Replacement ($newText)
                        $message = "Try block keyword $text should be uppercase"
                    }
                    ([StringCase]::Capital) {
                        $newText = $text | Convert-Case capital
                        $newExtent = $extent
                        | New-Correction -Replacement ($newText)
                        $message = "Try block keyword $text should be uppercase"
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
