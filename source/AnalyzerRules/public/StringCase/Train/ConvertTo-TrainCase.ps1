
function ConvertTo-TrainCase {
    <#
    .SYNOPSIS
        Convert the given phrase to Train-Case
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
            Write-Debug "Convert $phrase to Train-Case"
            $phrase | Convert-Case capital -Separator '-'
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
