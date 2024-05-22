
using namespace System.Text
function ConvertTo-CapitalCase {
    <#
    .SYNOPSIS
        Convert the given word to Capitalcase
    .DESCRIPTION
        CapitalCase is where the first letter of the word is uppercase and the rest are lowercase
        - Port
        - Server
    .NOTES
        If there are spaces in the input, they will be removed
    #>
    [CmdletBinding()]
    param(
        # The phrase to convert
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string[]]$InputObject
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        foreach ($phrase in $InputObject) {
            #! if we make it all lowercase first, then it will not be split
            $phrase | Convert-Case lower | Convert-Case capital

        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
