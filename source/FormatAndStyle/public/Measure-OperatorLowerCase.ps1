
function Measure-OperatorLowerCase {
    <#
    .SYNOPSIS
        Operators (-join, -split, etc...) should be lowercase.
    .DESCRIPTION
        Operators should not be capitalized.
        This rule can auto-fix violations.

        **BAD**
        - $Foo -Join $Bar
        **GOOD**
        - $Foo -join $Bar
    #>
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [ScriptBlockAst]$ScriptBlockAst
    )
    begin {
        $predicate = {
            param(
                [Ast]$Ast
            )
            (($Ast -is [BinaryExpressionAst]) -and
            ($Ast.error_position.Text -cmatch '[A-Z]'))
        }
    }
    process {
        try {
            $violations = $ScriptBlockAst.FindAll($predicate, $False)

            foreach ($violation in $violations) {
                $extent = $violation.Extent
                $error_position = $violation.error_position
                $start_column_number = $extent.StartColumnNumber
                $start = $error_position.StartColumnNumber - $start_column_number
                $end = $error_position.EndColumnNumber - $start_column_number

                $correction = ( -join @(
                        $extent.Text.SubString(0, $start),
                        $error_position.Text.ToLower(),
                        $extent.Text.SubString($end)
                    ))

                $correction_extent = [CorrectionExtent]::new(
                    $extent.StartLineNumber,
                    $extent.EndLineNumber,
                    $start_column_number,
                    $extent.EndColumnNumber,
                    $correction,
                    ''
                    )
                $suggested_corrections = New-Object System.Collections.ObjectModel.Collection['CorrectionExtent']
                [Void]$suggested_corrections.Add($correction_extent)

                [DiagnosticRecord[]]@{
                    Message              = 'Operators should be lowercase'
                    RuleName             = 'OperatorLowerCase'
                    Severity             = 'Warning'
                    Extent               = $extent
                    SuggestedCorrections = $suggested_corrections
                } | Write-Output
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
