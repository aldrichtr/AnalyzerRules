@{
  FunctionName = 'Format-SwitchStatement'
  AstType      = 'SwitchStatementAst'
  Categories   = @('FormatKeyword', 'FormatConditional')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'switch (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'SWITCH (''a'') { ''a'' { } }'
      Expected   = 'fail'
      Correction = 'switch'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'SWITCH (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'switch (''a'') { ''a'' { } }'
      Expected   = 'fail'
      Correction = 'SWITCH'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Switch (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'switch (''a'') { ''a'' { } }'
      Expected   = 'fail'
      Correction = 'Switch'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'SWITCH (''a'') { ''a'' { } }'
      Expected   = 'fail'
      Correction = 'switch'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'switch (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatConditional = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'switch (''a'') { ''a'' { } }'
      Expected   = 'fail'
      Correction = 'SWITCH'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatConditional = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'SWITCH (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'SWITCH (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatConditional = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'SWITCH (''a'') { ''a'' { } }'
      Expected   = 'pass'
    }
  )
}
