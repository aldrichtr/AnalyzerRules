
function Get-RuleCategory {
  <#
    .SYNOPSIS
        Get the Category Attribute of the given command
    #>
  [CmdletBinding()]
  param(
    # The name of the rule
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [string]$Name
  )
  process {
    try {
      $ruleCmd = Get-Command $Name
      if ($null -ne $ruleCmd) {
        $ruleCmd.ScriptBlock.Attributes |
          Where-Object { $_.TypeId.Name -eq 'RuleCategory' }
      }
    } catch {
      throw "There was an error finding command$Name`n$_"
    }

  }
}
