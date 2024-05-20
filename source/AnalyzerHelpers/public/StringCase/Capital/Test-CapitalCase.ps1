
function Test-CapitalCase {
    <#
    .SYNOPSIS
        Return true if the first letter is uppercase and the rest are lowercase
    #>
    [CmdletBinding()]
    param(
        # The word to be tested
        [Parameter(
        )]
        [string]$InputObject
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $capitalCasePattern = '^[A-Z]([a-z0-9])+'
    }
    process {
        $InputObject -cmatch $capitalCasePattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
