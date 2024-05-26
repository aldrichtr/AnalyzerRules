
@(
    @{
        TestInput = 'this-is-kebab-case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '-'
        }
        Expected = $true
    }
    @{
        TestInput = 'this-is-Not-kebab-case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '-'
        }
        Expected = $false
    }
)
