
function ConvertTo-PascalCase {
    <#
    .SYNOPSIS
        Convert the given phrase to PascalCase
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
            $phrase | Convert-Case capital
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
