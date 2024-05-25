@(
    @{WordCase = 'upper'; DontAllowDigits = $false; Expected = '[A-Z0-9]+'}
    @{WordCase = 'upper'; DontAllowDigits = $true;  Expected = '[A-Z]+'}
    #--
    @{WordCase = 'lower'; DontAllowDigits = $false; Expected = '[a-z0-9]+'}
    @{WordCase = 'lower'; DontAllowDigits = $true; Expected = '[a-z]+'}
    #--
    @{WordCase = 'capital'; DontAllowDigits = $false; Expected = '[A-Z][a-z0-9]+'}
    @{WordCase = 'capital'; DontAllowDigits = $true; Expected = '[A-Z][a-z]+'}
    #--
    @{WordCase = 'startLower'; DontAllowDigits = $false; Expected = '[a-z][a-zA-Z0-9]+'}
    @{WordCase = 'startLower'; DontAllowDigits = $true; Expected = '[a-z][a-zA-Z]+'}
    #--
    @{WordCase = 'startUpper'; DontAllowDigits = $false; Expected = '[A-Z][a-zA-Z0-9]+'}
    @{WordCase = 'startUpper'; DontAllowDigits = $true; Expected = '[A-Z][a-zA-Z]+'}
)
