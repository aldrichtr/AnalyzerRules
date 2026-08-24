@{
  FunctionName = 'Format-CatchClause'
  AstType      = 'CatchClauseAst'
  Categories   = @('FormatKeyword', 'FormatExceptionHandler')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'try { 1 } CATCH { }'
      Expected   = 'fail'
      Correction = 'catch'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'try { 1 } CATCH { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'CATCH'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'try { 1 } Catch { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'Catch'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'try { 1 } CATCH { }'
      Expected   = 'fail'
      Correction = 'catch'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'CATCH'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'try { 1 } CATCH { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'try { 1 } CATCH { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'try { 1 } CATCH { }'
      Expected   = 'pass'
    }
  )
}
