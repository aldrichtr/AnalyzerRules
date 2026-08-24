@{
  FunctionName = 'Format-BreakStatement'
  AstType      = 'BreakStatementAst'
  Categories   = @('FormatKeyword', 'FormatBranchingStatement')
  TestCases    = @(
    # ── Settings: Category set, FormatKeyword not set ──
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { break }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { BREAK }'
      Expected   = 'fail'
      Correction = 'break'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { BREAK }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { break }'
      Expected   = 'fail'
      Correction = 'BREAK'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { Break }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { break }'
      Expected   = 'fail'
      Correction = 'Break'
    }

    # ── Settings: FormatKeyword set, Category not set (fallback) ──
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { BREAK }'
      Expected   = 'fail'
      Correction = 'break'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { break }'
      Expected   = 'pass'
    }

    # ── Settings: Both set, Category overrides FormatKeyword ──
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords           = @{ Case = 'lower' }
        FormatBranchingStatement = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { break }'
      Expected   = 'fail'
      Correction = 'BREAK'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords           = @{ Case = 'lower' }
        FormatBranchingStatement = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { BREAK }'
      Expected   = 'pass'
    }

    # ── Settings: Neither set - no enforcement ──
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'function foo { BREAK }'
      Expected   = 'pass'
    }

    # ── Settings: Enabled = false ──
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatBranchingStatement = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'function foo { BREAK }'
      Expected   = 'pass'
    }
  )
}
