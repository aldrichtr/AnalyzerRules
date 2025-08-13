
function Get-RuleCategory {
    <#
    .SYNOPSIS
        Get the Category Attribute of the given command
    #>
    [CmdletBinding()]
    param(
      # The name of the rule
      [Parameter(
      )]
      [string]$Name
    )
    begin {
      $self = $MyInvocation.MyCommand
        Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    }
    process {
      try {
        $ruleCmd = Get-Command $Name
        $attributes = $ruleCmd.ScriptBlock.Attributes |
          Where-Object { $_.TypeId.Name -eq 'RuleCategory' }
      }
      catch {
        throw "There was an error finding command$Name`n$_"
      }

    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
