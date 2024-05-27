
function Test-SnakeCase {
    <#
    .SYNOPSIS
        Returns true if the given word is snake_Case
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
        Write-Debug "Testing phrase '$InputObject' for snake case"
        if ($DontAllowDigits) {
            $word = $withoutDigits
        } else {
            $word = $withDigits
        }
        $snakeCasePattern = "^${word}_${word}(_${word})*"
        Write-Debug "- using regex $snakeCasePattern"
        $InputObject -cmatch $snakeCasePattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
