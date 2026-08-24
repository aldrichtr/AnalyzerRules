
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

function Get-AnalyzerSettingPreset {
  <#
  .SYNOPSIS
     Return a list of the Preset Settings in the current version of PSScriptAnalyzer
  #>
  [CmdletBinding()]
  param()
  begin {}
  process {
    # TODO: Add a `Name` parameter to narrow the presets
    $baseDir = Get-AnalyzerModuleSettingsDirectory
    if ($baseDir | Test-Path -PathType Container) {

      foreach ($preset in [Settings]::GetSettingsPresets()) {
        $settingsInfo = @{
          PSTypeName = 'PSScriptAnalyzer.SettingsInfo'
          Name       = $preset
          Path       = (Join-Path $baseDir "$preset.psd1")
        }
        $settings = Import-PowerShellDataFile $settingsInfo.Path
        if ($null -ne $settings) {
          foreach ($key in $settings.Key) {
            $settingsInfo[$key] = $settings[$key]
          }
        }
        [PSCustomObject]$settingsInfo
      }
    }
  }
  end {}
}
