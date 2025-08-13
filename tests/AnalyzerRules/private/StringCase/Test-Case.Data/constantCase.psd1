
@(
    @{
        TestInput = 'THIS_IS_CONSTANT_CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '_'
        }
        Expect = $true
    }
    @{
        TestInput = 'THIS_IS_noT_CONSTANT_CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '_'
        }
        Expect = $false
    }
)
