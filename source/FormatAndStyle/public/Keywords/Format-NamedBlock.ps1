
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-NamedBlock {
    <#
    .SYNOPSIS
        Ensure Named script blocks (Begin, Process, etc...) are in the case given in the FormatNamedBlock setting.
    .DESCRIPTION
        The named blocks in a function are `begin`, `process`, `end`, `clean`.  There are three types of 'case'
        settings that can be configured in the Settings file under FormatNamedBlock, `lower`, `upper`, `capital`
        ```powershell
        Rules = @{
            FormatNamedBlock = @{
                Enabled = $true
                Case = 'lower'
            }
        }
        ```
    #>
    [CmdletBinding()]
    [OutputType([DiagnosticRecord[]])]
    param(
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [ScriptBlockAst]$ScriptBlockAst
    )
    begin {
        $DEFAULT_BLOCK_CASE = 'lower'

        $ruleName = (Format-RuleName)
        $results = New-ResultsCollection
        $corrections = New-CorrectionCollection
        $ruleArgs = Get-RuleSetting

        if (($null -eq $ruleArgs) -or (-not ($ruleArgs.Enabled))) { return $null }

        if ($null -eq $ruleArgs.Case) {
            $ruleArgs.Case = $DEFAULT_BLOCK_CASE
        }

        switch -Regex ($ruleArgs.Case) {
            '^low' { $case = [StringCase]::Lower }
            '^up' { $case = [StringCase]::Upper }
            '^cap' { $case = [StringCase]::Capital }
            default {
                Write-Verbose "'$($ruleArgs.Case)' is not a known setting.  Use 'lower', 'upper', or 'capital'"
                return $null
            }
        }


        $predicate = {
            param(
                [Parameter()]
                [Ast]$Ast
            )
            $text = $Ast.Extent.Text
            if (($Ast -is [NamedBlockAst]) -and
             ($text -imatch '^(begin|process|end|clean)')) {
                switch ($case) {
                    ([StringCase]::Lower) { $text | Test-LowerCase }
                    ([StringCase]::Upper) { $text | Test-UpperCase }
                    ([StringCase]::Capital) { $text | Test-CapitalCase }
                }
            }
        }
    }
    process {
        try {
            $violations = $ScriptBlockAst | Select-RuleViolation $predicate
            :violation foreach ($violation in $violations) {
                $extent = $violation.Extent
                $text = $extent.Text
                $options = @{
                    Severity = 'Warning'
                    Extent   = $extent
                }

                :case switch ($case) {
                    ([StringCase]::Lower) {
                        $newText = $text | ConvertTo-LowerCase
                        $newExtent = $extent
                        | New-PSScriptAnalyzerCorrection -Replacement ($newText)
                        $message = "Named block $text should be lowercase"
                    }
                    ([StringCase]::Upper) {
                        $newText = $text | ConvertTo-UpperCase
                        $newExtent = $extent
                        | New-PSScriptAnalyzerCorrection -Replacement ($newText)
                        $message = "Named block $text should be uppercase"
                    }
                    ([StringCase]::Capital) {
                        $newText = $text | ConvertTo-CapitalCase
                        $newExtent = $extent
                        | New-PSScriptAnalyzerCorrection -Replacement ($newText)
                        $message = "Named block $text should be uppercase"
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

                [void]$results.Add((New-PSScriptAnalyzerDiagnosticRecord @options))
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
    end {
        $results
    }
}
