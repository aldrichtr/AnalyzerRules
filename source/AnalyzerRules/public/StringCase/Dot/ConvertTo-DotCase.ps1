
using namespace System.Text
function ConvertTo-DotCase {
    <#
    .SYNOPSIS
        Convert the given phrase to dot.case
    .DESCRIPTION
        In dot case, each word is lowercase, and they are separated by an underscore '.'
        - usb.port
        - remaining.values.in.collection
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
            $phrase | Convert-Case lower -Separator '.'
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
