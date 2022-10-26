
function Measure-ParamKeywordLowerCase {
    <#
    .SYNOPSIS
        Ensure the param block keyword is lowercase with no trailing space.
    .DESCRIPTION
        The "p" of "param" should be lowercase and no space between 'param' and '('
        This rule can auto-fix violations.

        **BAD**
        - Param()
        - param ()

        **GOOD**
        - param()
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
            (($Ast -is [ParamBlockAst]) -and
             (-not ($Ast.Extent.Text -cmatch 'param\(')))
        }
    }
    process {
        try {
            $violations = $ScriptBlockAst.FindAll($predicate, $false)
            foreach ($violation in $violations) {
                $extent = $violation.Extent
                $correction = $extent.Text -replace '^Param\s*\(', 'param('

                $options = @{
                    TypeName     = $extent_type
                    ArgumentList = @($extent.StartLineNumber,
                        $extent.EndLineNumber,
                        $extent.StartColumnNumber,
                        $extent.EndColumnNumber,
                        $correction,
                        ''
                    )
                }
                $correction_extent = New-Object @options
                $suggested_corrections = New-Object System.Collections.ObjectModel.Collection['CorrectionExtent']
                [void]$suggested_corrections.Add($correction_extent)

                [DiagnosticRecord[]]@{
                    Message              = 'Param block keyword should be lowercase with no trailing spaces'
                    RuleName             = 'ParamKeywordLowerCase'
                    Severity             = 'Warning'
                    Extent               = $extent
                    SuggestedCorrections = $suggested_corrections
                } | Write-Output
            }
            return $results
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
