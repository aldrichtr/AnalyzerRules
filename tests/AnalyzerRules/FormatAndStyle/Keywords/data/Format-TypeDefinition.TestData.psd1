@{
  FunctionName = 'Format-TypeDefinition'
  AstType      = 'TypeDefinitionAst'
  Categories   = @('FormatKeyword', 'FormatTypeStructure')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'class Foo { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'CLASS Foo { }'
      Expected   = 'fail'
      Correction = 'class'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'CLASS Foo { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'class Foo { }'
      Expected   = 'fail'
      Correction = 'CLASS'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Class Foo { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'class Foo { }'
      Expected   = 'fail'
      Correction = 'Class'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'CLASS Foo { }'
      Expected   = 'fail'
      Correction = 'class'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'class Foo { }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'class Foo { }'
      Expected   = 'fail'
      Correction = 'CLASS'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatTypeStructure = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'CLASS Foo { }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'CLASS Foo { }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatTypeStructure = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'CLASS Foo { }'
      Expected   = 'pass'
    }
  )
}
