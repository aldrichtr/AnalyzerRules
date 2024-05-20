
function Test-CobolCase {
    <#
    .SYNOPSIS
        Returns true if the given word is COBOL-CASE
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
        $withoutDigits = '[A-Z]+'
        $withDigits = '[A-Z0-9]+'
    }
    process {
        if ($DontAllowDigits) {
            $word = $withoutDigits
        } else {
            $word = $withDigits
        }
        $cobolCasePattern = "^$word-$word(-$word)*"
        $InputObject -cmatch $cobolCasePattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
