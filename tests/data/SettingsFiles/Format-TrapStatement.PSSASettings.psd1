@{
  IncludeDefaultRules = $false

  CustomRulePath      = @( '.\stage\AnalyzerRules')

  IncludeRules        = @(
    'Format-TrapStatement'
  )

  Rules = @{
    FormatTrapStatement = @{
      Enabled = $true
      Case = 'lower'
    }
  }
}
