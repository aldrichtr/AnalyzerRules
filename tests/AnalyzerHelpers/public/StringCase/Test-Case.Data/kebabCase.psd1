
@(
    @{
        TestInput = 'this-is-kebab-case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '-'
        }
        Expect = $true
    }
    @{
        TestInput = 'this-is-Not-kebab-case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '-'
        }
        Expect = $false
    }
)
