
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-PSScriptAnalyzerCorrection {
    <#
    .SYNOPSIS
        Create a new PSSA Correction
    #>
    [Alias('New-Correction')]
    [CmdletBinding()]
    param(
        # Starting line number
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]$StartLineNumber,

        # Ending line number
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]$EndLineNumber,

        # Starting Column number
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]$StartColumnNumber,

        # Ending Column number
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]$EndColumnNumber,

        # The text to replace with
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]$ReplacementText,

        # Path to the file
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]$Path,

        # Description of the correction
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [string]$Description
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        [CorrectionExtent]$PSBoundParameters
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
