
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

function Get-AnalyzerModuleSettingsDirectory {
    <#
    .SYNOPSIS
        Return the Directory where the loaded PSScriptAnalyzer module stores the settings presets
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        [Settings]::GetShippedSettingsDirectory()
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
