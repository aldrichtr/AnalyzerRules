$dataDir = (Join-Path $pwd "tests" "data")
$settingsDir = (Join-Path $dataDir 'SettingsFiles')

Import-Module PSScriptAnalyzer -Force

$options = @{
  Settings  = (Join-Path $settingsDir "Format-TrapStatement.PSSASettings.psd1")
  Path = (Join-Path $dataDir "Format-TrapStatement.Data.ps1" )
  Debug = $true
  Verbose = $true
}
Invoke-ScriptAnalyzer @options
