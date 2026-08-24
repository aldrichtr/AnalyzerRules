@{
  FunctionName = 'Format-ParamBlock'
  AstType      = 'ParamBlockAst'
  Categories   = @('FormatKeyword', 'FormatParameterKeyword')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { param() }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { PARAM() }'
      Expected   = 'fail'
      Correction = 'param'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { PARAM() }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { param() }'
      Expected   = 'fail'
      Correction = 'PARAM'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { Param() }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { param() }'
      Expected   = 'fail'
      Correction = 'Param'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { PARAM() }'
      Expected   = 'fail'
      Correction = 'param'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { param() }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatParameterKeyword = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { param() }'
      Expected   = 'fail'
      Correction = 'PARAM'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatParameterKeyword = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { PARAM() }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'function foo { PARAM() }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatParameterKeyword = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'function foo { PARAM() }'
      Expected   = 'pass'
    }
  )
}
