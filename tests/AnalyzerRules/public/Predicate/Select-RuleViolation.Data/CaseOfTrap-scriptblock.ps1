
function Test-CaseOfTrap {
    <#
    .SYNOPSIS
        A test function for testing the case of the trap keyword
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
      trap { Write-Warning "Found it"}
      "Hello World"
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
