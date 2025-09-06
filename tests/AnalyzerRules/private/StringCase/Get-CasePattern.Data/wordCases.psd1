@(
    @{WordCase = 'upper'; DontAllowDigits = $false; Expect = '[A-Z0-9]+'}
    @{WordCase = 'upper'; DontAllowDigits = $true;  Expect = '[A-Z]+'}
    #--
    @{WordCase = 'lower'; DontAllowDigits = $false; Expect = '[a-z0-9]+'}
    @{WordCase = 'lower'; DontAllowDigits = $true; Expect = '[a-z]+'}
    #--
    @{WordCase = 'capital'; DontAllowDigits = $false; Expect = '[A-Z][a-z0-9]+'}
    @{WordCase = 'capital'; DontAllowDigits = $true; Expect = '[A-Z][a-z]+'}
    #--
    @{WordCase = 'startLower'; DontAllowDigits = $false; Expect = '[a-z][a-zA-Z0-9]+'}
    @{WordCase = 'startLower'; DontAllowDigits = $true; Expect = '[a-z][a-zA-Z]+'}
    #--
    @{WordCase = 'startUpper'; DontAllowDigits = $false; Expect = '[A-Z][a-zA-Z0-9]+'}
    @{WordCase = 'startUpper'; DontAllowDigits = $true; Expect = '[A-Z][a-zA-Z]+'}
)
