@{
  FunctionName = 'Format-ForEachStatement'
  AstType      = 'ForEachStatementAst'
  Categories   = @('FormatKeyword', 'FormatIterationControl')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'foreach ($i in 1..3) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'FOREACH ($i in 1..3) { }'
      Expected   = 'fail'
      Correction = 'foreach'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'FOREACH ($i in 1..3) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'foreach ($i in 1..3) { }'
      Expected   = 'fail'
      Correction = 'FOREACH'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Foreach ($i in 1..3) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'foreach ($i in 1..3) { }'
      Expected   = 'fail'
      Correction = 'Foreach'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'FOREACH ($i in 1..3) { }'
      Expected   = 'fail'
      Correction = 'foreach'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'foreach ($i in 1..3) { }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'foreach ($i in 1..3) { }'
      Expected   = 'fail'
      Correction = 'FOREACH'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'FOREACH ($i in 1..3) { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'FOREACH ($i in 1..3) { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'FOREACH ($i in 1..3) { }'
      Expected   = 'pass'
    }
  )
}
