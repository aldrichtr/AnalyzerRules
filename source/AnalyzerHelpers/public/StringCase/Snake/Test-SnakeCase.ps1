
function Test-TrainCase {
    <#
    .SYNOPSIS
        Returns true if the given word is Train-Case
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
        $withoutDigits = '[A-Z][a-z]+'
        $withDigits = '[A-Z][a-z0-9]+'
    }
    process {
        if ($DontAllowDigits) {
            $word = $withoutDigits
        } else {
            $word = $withDigits
        }
        $trainCasePattern = "^$word-$word(-$word)*"
        $InputObject -cmatch $trainCasePattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
