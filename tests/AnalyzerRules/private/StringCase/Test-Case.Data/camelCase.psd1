
@(
    @{
        TestInput = 'thisIsCamelCase'
        TestOptions = @{
            WordCase = 'capital'
            FirstWordCase = 'lower'
        }
        Expect = $true
    }
    @{
        TestInput = 'ThisIsnotcamelCase'
        TestOptions = @{
            WordCase = 'capital'
            FirstWordCase = 'lower'
        }
        Expect = $false
    }
)
