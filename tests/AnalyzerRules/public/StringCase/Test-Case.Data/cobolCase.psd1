
@(
    @{
        TestInput = 'THIS-IS-COBOL-CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '-'
        }
        Expect = $true
    }
    @{
        TestInput = 'THIS-IS-noT-COBOL-CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '-'
        }
        Expect = $false
    }
)
