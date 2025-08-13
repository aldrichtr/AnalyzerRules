
function Test-KebabCase {
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
        $self = $MyInvocation.MyCommand
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
        $kebabCasePattern = "^$word-$word(-$word)*"
        $InputObject -cmatch $kebabCasePattern
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
