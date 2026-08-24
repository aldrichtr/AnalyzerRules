@{
  FunctionName = 'Format-ForStatement'
  AstType      = 'ForStatementAst'
  Categories   = @('FormatKeyword', 'FormatIterationControl')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'for ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'FOR ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'fail'
      Correction = 'for'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'FOR ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'for ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'fail'
      Correction = 'FOR'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'For ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'for ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'fail'
      Correction = 'For'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'FOR ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'fail'
      Correction = 'for'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'for ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'for ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'fail'
      Correction = 'FOR'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'FOR ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'FOR ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'FOR ($i = 0; $i -lt 1; $i++) { }'
      Expected   = 'pass'
    }
  )
}
