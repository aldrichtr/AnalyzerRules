
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
      ValueFromPipeline
    )]
    [hashtable]$Table
  )
  begin {}
  process {
    [Helper]::Instance.SetRuleArguments($Table)
  }
  end {}
}
