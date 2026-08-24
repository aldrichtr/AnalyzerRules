
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

function Get-AnalyzerModuleSettingsDirectory {
  <#
  .SYNOPSIS
     Return the Directory where the loaded PSScriptAnalyzer module stores the settings presets
  #>
  [CmdletBinding()]
  param()
  [Settings]::GetShippedSettingsDirectory()
}