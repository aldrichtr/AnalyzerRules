@{
  FunctionName = 'Format-FunctionMember'
  AstType      = 'FunctionMemberAst'
  Categories   = @('FormatKeyword', 'FormatVisibility')
  TestCases    = @(
    # -- Settings: Category set, FormatKeyword not set --
    @{
      Name       = 'Category=lower, keyword is lower - no violation'
      Settings   = @{
        FormatVisibility = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'class Foo { static [void] DoThing() { } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=lower, keyword is UPPER - violation'
      Settings   = @{
        FormatVisibility = @{ Enabled = $true; Case = 'lower' }
      }
      Script     = 'class Foo { STATIC [void] DoThing() { } }'
      Expected   = 'fail'
      Correction = 'static'
    }
    @{
      Name       = 'Category=upper, keyword is upper - no violation'
      Settings   = @{
        FormatVisibility = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'class Foo { STATIC [void] DoThing() { } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=upper, keyword is lower - violation'
      Settings   = @{
        FormatVisibility = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'class Foo { static [void] DoThing() { } }'
      Expected   = 'fail'
      Correction = 'STATIC'
    }
    @{
      Name       = 'Category=capital, keyword is Capital - no violation'
      Settings   = @{
        FormatVisibility = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'class Foo { Static [void] DoThing() { } }'
      Expected   = 'pass'
    }
    @{
      Name       = 'Category=capital, keyword is lower - violation'
      Settings   = @{
        FormatVisibility = @{ Enabled = $true; Case = 'capital' }
      }
      Script     = 'class Foo { static [void] DoThing() { } }'
      Expected   = 'fail'
      Correction = 'Static'
    }

    # -- Settings: FormatKeyword set, Category not set (fallback) --
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is UPPER - violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'class Foo { STATIC [void] DoThing() { } }'
      Expected   = 'fail'
      Correction = 'static'
    }
    @{
      Name       = 'FormatKeyword=lower (fallback), keyword is lower - no violation'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
      }
      Script     = 'class Foo { static [void] DoThing() { } }'
      Expected   = 'pass'
    }

    # -- Settings: Both set, Category overrides FormatKeyword --
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, lower violates'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatVisibility = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'class Foo { static [void] DoThing() { } }'
      Expected   = 'fail'
      Correction = 'STATIC'
    }
    @{
      Name       = 'FormatKeyword=lower, Category=upper - Category wins, UPPER passes'
      Settings   = @{
        FormatKeywords = @{ Case = 'lower' }
        FormatVisibility = @{ Enabled = $true; Case = 'upper' }
      }
      Script     = 'class Foo { STATIC [void] DoThing() { } }'
      Expected   = 'pass'
    }

    # -- Settings: Neither set - no enforcement --
    @{
      Name       = 'No settings configured - no violation regardless of case'
      Settings   = @{}
      Script     = 'class Foo { STATIC [void] DoThing() { } }'
      Expected   = 'pass'
    }

    # -- Settings: Enabled = false --
    @{
      Name       = 'Category Enabled=false - no violation regardless of case'
      Settings   = @{
        FormatVisibility = @{ Enabled = $false; Case = 'lower' }
      }
      Script     = 'class Foo { STATIC [void] DoThing() { } }'
      Expected   = 'pass'
    }
  )
}
