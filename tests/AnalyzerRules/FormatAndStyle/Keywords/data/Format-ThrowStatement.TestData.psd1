@{
  FunctionName = 'Format-ThrowStatement'
  AstType      = 'ThrowStatementAst'
  Categories   = @('FormatKeyword', 'FormatExceptionHandler')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { throw ''error'' }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { THROW ''error'' }'
      Expected   = 'fail'
      Correction = 'throw'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { THROW ''error'' }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { throw ''error'' }'
      Expected   = 'fail'
      Correction = 'THROW'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { Throw ''error'' }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { throw ''error'' }'
      Expected   = 'fail'
      Correction = 'Throw'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { THROW ''error'' }'
      Expected   = 'fail'
      Correction = 'throw'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { throw ''error'' }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { throw ''error'' }'
      Expected   = 'fail'
      Correction = 'THROW'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { THROW ''error'' }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'function foo { THROW ''error'' }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'function foo { THROW ''error'' }'
      Expected   = 'pass'
    }
  )
}
