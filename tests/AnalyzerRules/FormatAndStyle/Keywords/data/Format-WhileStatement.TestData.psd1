@{
  FunctionName = 'Format-WhileStatement'
  AstType      = 'WhileStatementAst'
  Categories   = @('FormatKeyword', 'FormatIterationControl')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'while ($true) { break }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'WHILE ($true) { break }'
      Expected   = 'fail'
      Correction = 'while'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'WHILE ($true) { break }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'while ($true) { break }'
      Expected   = 'fail'
      Correction = 'WHILE'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'While ($true) { break }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'while ($true) { break }'
      Expected   = 'fail'
      Correction = 'While'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'WHILE ($true) { break }'
      Expected   = 'fail'
      Correction = 'while'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'while ($true) { break }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'while ($true) { break }'
      Expected   = 'fail'
      Correction = 'WHILE'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'WHILE ($true) { break }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'WHILE ($true) { break }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'WHILE ($true) { break }'
      Expected   = 'pass'
    }
  )
}
