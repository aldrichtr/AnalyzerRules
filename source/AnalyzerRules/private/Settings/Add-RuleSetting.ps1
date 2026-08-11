
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer
function Add-RuleSetting {
  <#
    .SYNOPSIS
        Add the settings to the global settings table
    #>
  [CmdletBinding()]
  param(
    # the settings to be added
    [Parameter(
      Position = 0,
      ValueFromPipeline
    )]
    [hashtable]$Table
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
  }
  process {
    [Helper]::Instance.SetRuleArguments($Table)
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
