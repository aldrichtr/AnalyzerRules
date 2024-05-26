
function Test-DotCase {
    <#
    .SYNOPSIS
        Returns true if the given word is kebab-case
    #>
    [CmdletBinding()]
    param(
        # The word to test
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$InputObject,

        # Do not allow numbers in words
        [Parameter(
        )]
        [switch]$DontAllowDigits
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $withoutDigits = '[a-z]+'
        $withDigits = '[a-z0-9]+'
    }
    process {
        if ($DontAllowDigits) {
            $word = $withoutDigits
        } else {
            $word = $withDigits
        }
        $dotCasePattern = "^$word\.$word(\.$word)*"
        $InputObject -cmatch $dotCasePattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
