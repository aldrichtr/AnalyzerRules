
@(
    @{
        TestInput = 'This-Is-Train-Case'
        TestOptions = @{
            WordCase = 'capital'
            Separator = '-'
        }
        Expect = $true
    }
    @{
        TestInput = 'This-Is-NOT_Train-Case'
        TestOptions = @{
            WordCase = 'capital'
            Separator = '-'
        }
        Expect = $false
    }
)
