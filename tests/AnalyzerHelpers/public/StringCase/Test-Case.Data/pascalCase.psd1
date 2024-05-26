
@(
    @{
        TestInput = 'ThisIsPascalCase'
        TestOptions = @{
            WordCase = 'capital'
        }
        Expected = $true
    }
    @{
        TestInput = 'thisIsnotpascalCase'
        TestOptions = @{
            WordCase = 'capital'
        }
        Expected = $false
    }
)
