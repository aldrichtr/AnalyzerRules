@{
  FunctionName = 'Format-IfStatement'
  AstType      = 'IfStatementAst'
  Categories   = @('FormatKeyword', 'FormatConditional')
  TestCases    = @(
    # -- if keyword (leading, matches ^anchor) --
    @{
      Name       = 'Category=lower, if is lower - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'if ($true) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, IF is upper - violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'IF ($true) { }'
      Expected   = 'fail'
      Correction = 'if'
    }
    @{
      Name       = 'Category=upper, IF is upper - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'IF ($true) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, if is lower - violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'if ($true) { }'
      Expected   = 'fail'
      Correction = 'IF'
    }
    @{
      Name       = 'Category=capital, If is capital - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'If ($true) { }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, if is lower - violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'if ($true) { }'
      Expected   = 'fail'
      Correction = 'If'
    }

    # -- Settings cascade --
    @{
      Name       = 'FormatKeyword=upper (fallback), if is lower - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'upper' }
      }
      Script     = 'if ($true) { }'
      Expected   = 'fail'
      Correction = 'IF'
    }
    @{
      Name       = 'FormatKeyword=upper, Category=lower - Category wins, if passes'
      Settings   = @{
        FormatKeywords    = @{ Case = 'upper' }
        FormatConditional = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'if ($true) { }'
      Expected   = 'pass'
    }

    # -- No settings --
    @{
      Name       = 'No settings configured - no violation'
      Settings   = @{}
      Script     = 'IF ($true) { }'
      Expected   = 'pass'
    }

    # -- Disabled --
    @{
      Name       = 'Category Enabled=false - no violation'
      Settings   = @{
        FormatConditional = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'IF ($true) { }'
      Expected   = 'pass'
    }
  )
}
