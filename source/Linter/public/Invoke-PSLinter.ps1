
function Invoke-PSLinter {
    <#
    .SYNOPSIS
        Invoke the main PSLinter program
    #>
    [CmdletBinding()]
    param(
        # Arguments supplied to the main script
        [Parameter(
            ValueFromRemainingArguments
        )]
        [array]$Arguments
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        "$($PSStyle.Foreground.Cyan)Starting PSLint$($PSStyle.Reset)"
        "$($PSStyle.Foreground.Blue)Arguments are $($Arguments -Join ', ')$($PSStyle.Reset)"
        #TODO: If a module path is specified, check all commands and verify each module is properly required
        switch -Regex ($Arguments[0]) {
            '^--' {
                "$($PSStyle.Foreground.BrightBlack)Option called$($PSStyle.Reset)"
            }
        }
   }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
