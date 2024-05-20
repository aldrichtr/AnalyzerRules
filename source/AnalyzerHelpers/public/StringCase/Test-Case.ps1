
function Test-Case {
    <#
    .SYNOPSIS
        Returns true if the given string matches the parameters given
    #>
    [CmdletBinding()]
    param(
        # The phrase to be tested
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string]$InputObject,

        # The case of the first word
        [Parameter(
        )]
        [ValidateSet('lower', 'upper', 'capital', 'startLower', 'startUpper')]
        [string]$FirstWordCase,

        # The case of the words in the phrase
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [ValidateSet('lower', 'upper', 'capital', 'startLower', 'startUpper')]
        [string]$WordCase,

        # The separator character between words
        [Parameter(
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$Separator,

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
        $lowerWithDigit = '[a-z0-9]'
        $lowerNoDigit   = '[a-z]'
        $upperWithDigit = '[A-Z0-9]'
        $upperNoDigit   = '[A-Z]'
        $up             = 1
        $cancelChars    = @('.', ' ', '-', '_')
    }
    process {
        #TODO: Refactor all Test-*Case functions to use this based on parameters
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
