
function Get-CasePattern {
    <#
    .SYNOPSIS
        Return the regex pattern associated with the case
    .LINK
        Test-Case
    #>
    param(
        # The name of the case
        [Parameter(
        )]
        [ValidateSet('upper', 'lower', 'capital', 'startLower', 'startUpper')]
        [string]$Case,

        [Parameter(
        )]
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
    switch ($Case) {
        'upper' { "$upper+" }
        'lower' { "$lower+" }
        'capital' { "[A-Z]$lower+" }
        'startLower' { "[a-z]$any+" }
        'startUpper' { "[A-Z]$any+" }
    }
}
