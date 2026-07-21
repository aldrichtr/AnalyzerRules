@(
    @{
        TestInput = 'this.is.dot.case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '\.'
        }
        Expect = $true
    }
    @{
        TestInput = 'this.is.Not.dot.case'
        TestOptions = @{
            WordCase = 'lower'
            Separator = '\.'
        }
        Expect = $false
    }
)
