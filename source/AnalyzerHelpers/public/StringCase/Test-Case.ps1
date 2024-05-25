using namespace System.Text


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
        $up             = 1
        $cancelChars    = @('.', ' ', '-', '_')

        $pattern = [StringBuilder]::new()

        function Set-Pattern {
            param(
                [string]$case,
                [switch]$DontAllowDigits
            )
            if ($DontAllowDigits) {
                $lower     = '[a-z]'
                $upper     = '[A-Z]'
                $any       = '[a-zA-Z]'
            } else {
                $lower   = '[a-z0-9]'
                $upper   = '[A-Z0-9]'
                $any       = '[a-zA-Z0-9]'
            }
            switch ($case) {
                'upper' { $upper }
                'lower' { $lower }
                'capital' { "$upper$lower+" }
                'startLower' { "$lower$any+"}
                'startUpper' { "$upper$any+"}
            }
        }
    }
    process {
        #TODO: Refactor all Test-*Case functions to use this based on parameters
        [void]$pattern.Append('^')
        $wordCasePattern = (Set-Pattern $WordCase $DontAllowDigits)
        if ($PSBoundParameters.ContainsKey('FirstWordCase')) {
            [void]$pattern.Append( (Set-Pattern $FirstWordCase $DontAllowDigits) )
        } else {
            [void]$pattern.Append($wordCasePattern)
        }

        [void]$pattern.Append($Separator)
        [void]$pattern.Append($wordCasePattern)
        [void]$pattern.AppendJoin('', @(
            '(',
            $Separator,
            $wordCasePattern,
            ')'
        ))
        [void]$pattern.Append('$')

        Write-Debug "Using Pattern: '$($pattern.ToString())"
        $InputObject -cmatch $pattern.ToString()
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
