@(
    @{
        TestInput = 'this_is_snake_case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '_'
        }
        Expect = $true
    }
    @{
        TestInput = 'this_is_Not_snake_case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '_'
        }
        Expect = $false
    }
)
