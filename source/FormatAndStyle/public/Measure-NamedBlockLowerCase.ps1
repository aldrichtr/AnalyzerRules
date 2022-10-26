
function Measure-NamedBlockLowerCase {
    <#
    .SYNOPSIS
        Ensure Named script blocks (Begin, Process, etc...) are lowercase.
    .DESCRIPTION
        The named script block names should be lowercase.  This rule can auto-fix violations.

        **BAD**
        - Process {...}

        **GOOD**
        - process {...}
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
                [Parameter()]
                [Ast]$Ast
            )
            (($Ast -is [NamedBlockAst]) -and
             (-not $Ast.Unnamed) -and
             (-not ($Ast.Extent.Text -cmatch '^[a-z]')))
        }
    }
    process {
        try {
            $violations = $ScriptBlockAst.FindAll($predicate, $False)
            foreach ($violation in $violations) {
                $extent = $violation.Extent
                $correction = ( -join @(
                        $extent.Text[0].ToString().ToLower(),
                        $extent.Text.Substring(1)
                    ))
                $correction_extent = [CorrectionExtent]::new(
                    $extent.StartLineNumber,
                    $extent.EndLineNumber,
                    $extent.StartColumnNumber,
                    $extent.EndColumnNumber,
                    $correction,
                    '')
                $suggested_corrections = [System.Collections.ObjectModel.Collection]::new([CorrectionExtent])
                [void]$suggested_corrections.Add($correction_extent)
                [DiagnosticRecord[]]@{
                    Message              = 'Named script block names should be lowercase'
                    RuleName             = 'NamedBlockLowerCase'
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
