@{
  FunctionName = 'Format-DataStatement'
  AstType      = 'DataStatementAst'
  Categories   = @('FormatKeyword', 'FormatNamedBlock')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'data { ''hello'' }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'DATA { ''hello'' }'
      Expected   = 'fail'
      Correction = 'data'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'DATA { ''hello'' }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'data { ''hello'' }'
      Expected   = 'fail'
      Correction = 'DATA'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Data { ''hello'' }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'data { ''hello'' }'
      Expected   = 'fail'
      Correction = 'Data'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'DATA { ''hello'' }'
      Expected   = 'fail'
      Correction = 'data'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'data { ''hello'' }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'data { ''hello'' }'
      Expected   = 'fail'
      Correction = 'DATA'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'DATA { ''hello'' }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'DATA { ''hello'' }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'DATA { ''hello'' }'
      Expected   = 'pass'
    }
  )
}
