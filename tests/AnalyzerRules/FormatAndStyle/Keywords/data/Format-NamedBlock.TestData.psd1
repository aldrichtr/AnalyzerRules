@{
  FunctionName = 'Format-NamedBlock'
  AstType      = 'NamedBlockAst'
  Categories   = @('FormatKeyword', 'FormatNamedBlock')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'begin { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'BEGIN { }'
      Expected   = 'fail'
      Correction = 'begin'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'BEGIN { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'begin { }'
      Expected   = 'fail'
      Correction = 'BEGIN'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Begin { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'begin { }'
      Expected   = 'fail'
      Correction = 'Begin'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'BEGIN { }'
      Expected   = 'fail'
      Correction = 'begin'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'begin { }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'begin { }'
      Expected   = 'fail'
      Correction = 'BEGIN'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatNamedBlock = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'BEGIN { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'BEGIN { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatNamedBlock = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'BEGIN { }'
      Expected   = 'pass'
    }
  )
}
