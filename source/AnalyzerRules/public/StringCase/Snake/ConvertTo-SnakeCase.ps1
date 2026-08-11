
function ConvertTo-SnakeCase {
    <#
    .SYNOPSIS
        Convert the given phrase to snake_case
    .DESCRIPTION
        In snake case, each word is lowercase, and they are separated by an underscore '_'
        - usb_port
        - remaining_values_in_collection
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
        $self = $MyInvocation.MyCommand
Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        foreach ($phrase in $InputObject) {
            $phrase | Convert-Case lower -Separator '_'
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
