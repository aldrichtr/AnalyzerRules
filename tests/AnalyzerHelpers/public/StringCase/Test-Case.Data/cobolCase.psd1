
@(
    @{
        TestInput = 'THIS-IS-COBOL-CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '-'
        }
        Expected = $true
    }
    @{
        TestInput = 'THIS-IS-noT-COBOL-CASE'
        TestOptions = @{
            WordCase = 'upper'
            Separator = '-'
        }
        Expected = $false
    }
)
