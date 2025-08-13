
function Test-CaseOfTrap {
    <#
    .SYNOPSIS
        A test function for testing the case of the trap keyword
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        $self = $MyInvocation.MyCommand
Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
      TRAP { Write-Warning "Found it"}
      "Hello World"
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
