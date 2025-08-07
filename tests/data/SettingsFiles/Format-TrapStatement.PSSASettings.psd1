@{
  IncludeDefaultRules = $false

  CustomRulePath      = @(
    '.\stage\AnalyzerHelpers',
    '.\stage\FormatAndStyle'
  )

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
