@{
  FunctionName = 'Format-TryStatement'
  AstType      = 'TryStatementAst'
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
      Script     = 'TRY { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'try'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'TRY { 1 } catch { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'TRY'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Try { 1 } catch { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'try { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'Try'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'TRY { 1 } catch { }'
      Expected   = 'fail'
      Correction = 'try'
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
      Correction = 'TRY'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'TRY { 1 } catch { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'TRY { 1 } catch { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'TRY { 1 } catch { }'
      Expected   = 'pass'
    }
  )
}
