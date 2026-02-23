
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer
function Get-RuleSetting {
  <#
    .SYNOPSIS
        Get the settings for the given rule
    #>
  [CmdletBinding()]
  param(
    # The name of the function used in the Settings File
    # If not given, then the caller's name will be used
    [Parameter(
      Position = 0,
      ValueFromPipeline
    )]
    [string]$KeyName
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
  }
  process {
    $settings = [Helper]::Instance.GetRuleArguments()

    if (($null -ne $settings) -and
        ($settings.Keys.Count -gt 0)) {
      Write-Debug "Retrieved settings"
      if ($PSBoundParameters.ContainsKey('KeyName')) {
        <#
         # ------------------------------------------------------------------
         # Our function names are in `Verb-Noun` format, but our Settings
         # are going to be in the form of `VerbNoun`.  So, just in case the
         # function name was passed in, format it before we do the lookup
         # ------------------------------------------------------------------
         #>
        if ($KeyName -match '(\w+)-(\w+)<\w+>') {
          $KeyName = Format-RuleName $KeyName
          | Select-Object -ExpandProperty ShortName
        }
        if ($settings.ContainsKey($KeyName)) {
          Write-Debug "Found $KeyName in settings:"
          Write-Debug "$($settings[$KeyName] | ConvertTo-Json)"
          $settings[$KeyName]
        } else {
          Write-Debug "No setting found for $KeyName"
        }
      } else {
        Write-Debug "Settings:`n$($settings | ConvertTo-Json)"
        $settings
      }
    } else {
      Write-Debug "No settings were retrieved"
    }
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
