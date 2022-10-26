
function Measure-ParameterAttributeIsTrue {
    <#
    .SYNOPSIS
        Ensure parameter attributes do not use '= $true'
    .DESCRIPTION
        Parameter attributes should be listed if they are true, and ommitted if they are false.
        This rule can auto-fix violations.

        **BAD**
        - [Parameter(
            Mandatory = $true
           )]
        - [Parameter(
            Mandatory = $false
           )]

        **GOOD**
        - [Parameter(
            Mandatory
           )]
        - [Parameter(
           )]
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
            (
                ($Ast -is [NamedAttributeArgumentAst]) -and
                ($Ast.Parent.TypeName -like 'Parameter') -and
                ($Ast.Extent.Text -match '\w+\s*=\s*\$true')
            )
        }
    }
    process {
        try {
            $violations = $ScriptBlockAst.FindAll($predicate, $false)
            foreach ($violation in $violations) {
                $extent = $violation.Extent
                $correction = ( $extent.Text -replace '\s*=\s*\$true', '')
                $correction_extent = [CorrectionExtent]::new(
                    $extent.StartLineNumber,
                    $extent.EndLineNumber,
                    $extent.StartColumnNumber,
                    $extent.EndColumnNumber,
                    $correction,
                    '')
                $suggested_corrections = New-Object System.Collections.ObjectModel.Collection['CorrectionExtent']
                [void]$suggested_corrections.Add($correction_extent)

                [DiagnosticRecord[]]@{
                    Message              = 'Parameter attributes should be set if true'
                    RuleName             = 'ParameterAttributeIsTrue'
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
