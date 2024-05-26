
@(
    @{
        TestInput = 'This-Is-Train-Case'
        TestOptions = @{
            WordCase = 'capital'
            Separator = '-'
        }
        Expected = $true
    }
    @{
        TestInput = 'This-Is-NOT_Train-Case'
        TestOptions = @{
            WordCase = 'capital'
            Separator = '-'
        }
        Expected = $false
    }
)
