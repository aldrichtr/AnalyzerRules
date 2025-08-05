
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

function Merge-Setting {
    <#
    .SYNOPSIS
        Create a single Analyzer Settings table from multiple tables
    .NOTES
        Uses Metadata\Update-MetaData
    .EXAMPLE
      Get-Item $env:APPDATA\pwsh\pssa | Merge-Setting
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
                    if ($location.Name -match '\.psd1$') {
                        try {
                            $fragment = Import-PowerShellDataFile -Path $location.FullName
                            $Settings = Update-Object -UpdateObject $fragment
                        }
                        catch {
                            Write-Warning "Could not import $($location.Name)"
                        }
                    }
                }
            } else {
              Write-Warning "$location is not a valid path"
            }
        }
    }
    end {
        $Settings
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
