@{
  FunctionName = 'Format-DoUntilStatement'
  AstType      = 'DoUntilStatementAst'
  Categories   = @('FormatKeyword', 'FormatIterationControl')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'do { } until ($true)'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'DO { } until ($true)'
      Expected   = 'fail'
      Correction = 'do'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'DO { } until ($true)'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'do { } until ($true)'
      Expected   = 'fail'
      Correction = 'DO'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'Do { } until ($true)'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'do { } until ($true)'
      Expected   = 'fail'
      Correction = 'Do'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'DO { } until ($true)'
      Expected   = 'fail'
      Correction = 'do'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'do { } until ($true)'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'do { } until ($true)'
      Expected   = 'fail'
      Correction = 'DO'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatIterationControl = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'DO { } until ($true)'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'DO { } until ($true)'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatIterationControl = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'DO { } until ($true)'
      Expected   = 'pass'
    }
  )
}
