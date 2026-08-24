@{
  FunctionName = 'Format-FunctionDefinition'
  AstType      = 'FunctionDefinitionAst'
  Categories   = @('FormatKeyword', 'FormatTypeStructure')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'function foo { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'FUNCTION foo { }'
      Expected   = 'fail'
      Correction = 'function'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'FUNCTION foo { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { }'
      Expected   = 'fail'
      Correction = 'FUNCTION'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Function foo { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'function foo { }'
      Expected   = 'fail'
      Correction = 'Function'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'FUNCTION foo { }'
      Expected   = 'fail'
      Correction = 'function'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'function foo { }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'function foo { }'
      Expected   = 'fail'
      Correction = 'FUNCTION'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'FUNCTION foo { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'FUNCTION foo { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'FUNCTION foo { }'
      Expected   = 'pass'
    }
  )
}
