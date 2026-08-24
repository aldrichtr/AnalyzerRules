@{
  FunctionName = 'Test-Case'
  TestCases    = @(
    # -- Camel
    @{ TestInput = 'thisIsCamelCase'; TestOptions = @{ WordCase = 'capital'; FirstWordCase = 'lower' }; Expect = $true }
    @{ TestInput = 'ThisIsnotcamelCase'; TestOptions = @{ WordCase = 'capital'; FirstWordCase = 'lower' }; Expect = $false }
    # -- Cobol
    @{ TestInput = 'THIS-IS-COBOL-CASE'; TestOptions = @{ WordCase = 'upper'; Separator = '-' }; Expect = $true }
    @{ TestInput = 'THIS-IS-noT-COBOL-CASE'; TestOptions = @{ WordCase = 'upper'; Separator = '-' }; Expect = $false }
    # -- Constant
    @{ TestInput = 'THIS_IS_CONSTANT_CASE'; TestOptions = @{ WordCase = 'upper'; Separator = '_' }; Expect = $true }
    @{ TestInput = 'THIS_IS_noT_CONSTANT_CASE'; TestOptions = @{ WordCase = 'upper'; Separator = '_' }; Expect = $false }
    # -- Dot
    @{ TestInput = 'this.is.dot.case'; TestOptions = @{ WordCase = 'lower'; Separator = '\.' }; Expect = $true }
    @{ TestInput = 'this.is.Not.dot.case'; TestOptions = @{ WordCase = 'lower'; Separator = '\.' }; Expect = $false }
    # -- Kebab
    @{ TestInput = 'this-is-kebab-case'; TestOptions = @{ WordCase = 'lower'; Separator = '-' }; Expect = $true }
    @{ TestInput = 'this-is-Not-kebab-case'; TestOptions = @{ WordCase = 'lower'; Separator = '-' }; Expect = $false }
    # -- Pascal
    @{ TestInput = 'ThisIsPascalCase'; TestOptions = @{ WordCase = 'capital' }; Expect = $true }
    @{ TestInput = 'thisIsnotpascalCase'; TestOptions = @{ WordCase = 'capital' }; Expect = $false }
    # -- Snake
    @{ TestInput = 'this_is_snake_case'; TestOptions = @{ WordCase = 'lower'; Separator = '_' }; Expect = $true }
    @{ TestInput = 'this_is_Not_snake_case'; TestOptions = @{ WordCase = 'lower'; Separator = '_' }; Expect = $false }
    # -- Train
    @{ TestInput = 'This-Is-Train-Case'; TestOptions = @{ WordCase = 'capital'; Separator = '-' }; Expect = $true }
    @{ TestInput = 'This-Is-NOT_Train-Case'; TestOptions = @{ WordCase = 'capital'; Separator = '-' }; Expect = $false }
  )
}
