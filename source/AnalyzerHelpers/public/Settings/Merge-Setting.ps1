
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

function Merge-Setting {
    <#
    .SYNOPSIS
        Create a single Analyzer Settings table from multiple tables
    .NOTES
        Uses Metadata\Update-MetaData
    #>
    [CmdletBinding()]
    param(
        # Specifies a path to one or more locations.
        [Parameter(
        Position = 1,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [string[]]$Path,

        # File filter
        [Parameter(
            Position = 0
        )]
        [hashtable]$Settings
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $defaultConfigFile = '\.pssa\.psd1$'
    }
    process {
        if ([string]::IsNullorEmpty($Settings)) {
            Write-Debug "No settings where given"
            $Settings = @{}
        }
        foreach ($location in $Path) {
            Write-Debug "$location was given"
            if ($location | Test-Path) {
                Write-Debug "- Valid Path"
                $location = Get-Item $location
                if ($location.PSIsContainer) {
                    Write-Debug "  - It is a directory"
                    Get-ChildItem $location | Merge-Setting $Settings
                } else {
                    Write-Debug "  - It is a file"
                    if ($location.Name -match $defaultConfigFile) {
                        try {
                            $fragment = Import-PowerShellDataFile -Path $location.FullName
                            Write-Debug "  - Loaded settings"
                            Write-Debug ('-' * 80)
                            Write-Debug "Updating Settings with $($fragment | ConvertTo-Psd | Out-String)"
                            Write-Debug "Before update : Settings`n$($Settings | ConvertTo-Psd | Out-String)"

                            $Settings = Update-Object -InputObject $Settings -UpdateObject (Import-PowerShellDataFile $location.FullName)
                            Write-Debug "After update : Settings`n$($Settings | ConvertTo-Psd | Out-String)"
                            Write-Debug ('-' * 80)
                        }
                        catch {
                            Write-Warning "Could not import $($location.Name)"
                        }
                    }
                }
            }
        }
    }
    end {
        $Settings
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
