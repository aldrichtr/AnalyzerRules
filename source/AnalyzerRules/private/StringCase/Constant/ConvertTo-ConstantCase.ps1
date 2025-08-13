
function ConvertTo-ConstantCase {
    <#
    .SYNOPSIS
        Convert the given phrase to CONSTANT_CASE
    #>
    [CmdletBinding()]
    param(
        # The phrase to be converted
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
            $phrase | Convert-Case upper -Separator '_'
        }

    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
