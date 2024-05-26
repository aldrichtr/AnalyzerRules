@(
    @{
        TestInput = 'this.is.dot.case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '\.'
        }
        Expected = $true
    }
    @{
        TestInput = 'this.is.Not.dot.case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '\.'
        }
        Expected = $false
    }
)
