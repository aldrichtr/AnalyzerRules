
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer
function Get-AnalyzerSettingPreset {
    <#
    .SYNOPSIS
        Return a list of the Preset Settings in the current version of PSScriptAnalyzer
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
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
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
