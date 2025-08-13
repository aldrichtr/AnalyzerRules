
function Test-CamelCase {
    <#
    .SYNOPSIS
        Return true if the given word is in camelCase
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
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $wordWithDigit = '[a-z0-9]'
        $wordNoDigit   = '[a-z]'
        $up            = 1
        $cancelChars = @('.', ' ', '-', '_')
    }
    process {
        # The amount of uppercase is set to 1 (strict) by default
        if ($PSBoundParameters.ContainsKey('ConsecutiveUppercase')) {
            $up = $ConsecutiveUppercase
        }

        if ($DontAllowDigits) {
            $char = $wordNoDigit
        } else {
            $char = $wordWithDigit
        }

        $camelCasePattern = (@(
                '(?mx)',
                '^[a-z]', # Start with a lowercase letter
                "$char*", # followed by zero or more characters
                '(', # either
                "  ([A-Z]{1,$up}$char+)*", #   possible word starting with configured consecutive uppercase,
                "  [A-Z]{0,$up}", #   configured consecutive uppercase
                '|', # or
                "  ($char+[A-Z]{1,$up})*", #   possible word with configured consecutive uppercase in it
                '  |', #   or
                "  [A-Z]{1,$up}", #   one or more consecutive uppercase characters
                ')$'
            ) -join '')
        Write-Debug "The pattern to verify with : `n'$camelCasePattern'"
        $indexOfSpecial = $InputObject.IndexOfAny($cancelChars)
        if ($indexOfSpecial -ge 0) {
            Write-Debug "Special character found at index $indexOfSpecial"
            $false
        } else {
            ($InputObject -cmatch $camelCasePattern)
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
