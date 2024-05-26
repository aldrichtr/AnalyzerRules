
@(
    @{
        TestInput = 'THIS_IS_CONSTANT_CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '_'
        }
        Expected = $true
    }
    @{
        TestInput = 'THIS_IS_noT_CONSTANT_CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '_'
        }
        Expected = $false
    }
)
