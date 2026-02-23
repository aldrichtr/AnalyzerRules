
@(
    @{
        TestInput = 'ThisIsPascalCase'
        TestOptions = @{
            WordCase = 'capital'
        }
        Expect = $true
    }
    @{
        TestInput = 'thisIsnotpascalCase'
        TestOptions = @{
            WordCase = 'capital'
        }
        Expect = $false
    }
)
