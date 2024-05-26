
@(
    @{
        TestInput = 'thisIsCamelCase'
        TestOptions = @{
            WordCase = 'capital'
            FirstWordCase = 'lower'
        }
        Expected = $true
    }
    @{
        TestInput = 'ThisIsnotcamelCase'
        TestOptions = @{
            WordCase = 'capital'
            FirstWordCase = 'lower'
        }
        Expected = $false
    }
)
