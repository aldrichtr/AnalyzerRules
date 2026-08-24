@{
  FunctionName = 'Format-TrapStatement'
  AstType      = 'TrapStatementAst'
  Categories   = @('FormatKeyword', 'FormatExceptionHandler')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { trap { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { TRAP { Write-Warning ''trapped'' } }'
      Expected   = 'fail'
      Correction = 'trap'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { TRAP { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { trap { Write-Warning ''trapped'' } }'
      Expected   = 'fail'
      Correction = 'TRAP'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { Trap { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { trap { Write-Warning ''trapped'' } }'
      Expected   = 'fail'
      Correction = 'Trap'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { TRAP { Write-Warning ''trapped'' } }'
      Expected   = 'fail'
      Correction = 'trap'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { trap { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { trap { Write-Warning ''trapped'' } }'
      Expected   = 'fail'
      Correction = 'TRAP'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatExceptionHandler = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { TRAP { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'function foo { TRAP { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatExceptionHandler = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'function foo { TRAP { Write-Warning ''trapped'' } }'
      Expected   = 'pass'
    }
  )
}
