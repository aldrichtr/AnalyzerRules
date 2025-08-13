
function Test-PascalCase {
    <#
    .SYNOPSIS
        Return true if the given word is in PascalCase
    .LINK
        <https://github.com/roubles/casing>
    #>
    [CmdletBinding()]
    param(
        # The word to test
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$InputObject,

        # The number of consecutive uppercase letters
        # By default, only one upper
        [Parameter(
            Position = 0
        )]
        [int]$ConsecutiveUppercase,

        # Digits are not allowed
        [Parameter(
        )]
        [switch]$DontAllowDigits
    )
    begin {
        $self = $MyInvocation.MyCommand
Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        Test-Case @PSBoundParameters -WordCase capital
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
