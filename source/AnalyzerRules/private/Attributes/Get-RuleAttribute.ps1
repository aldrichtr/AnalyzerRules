
using namespace System.Collections
using namespace System.Management.Automation

function Get-RuleAttribute {
  <#
  .SYNOPSIS
     Get the Attributes associated with the given rule function
  #>
  [CmdletBinding()]
  param(
    # The name of the rule
    [Parameter(
      ValueFromPipeline
    )]
    [Object]$Rule,

    # Optionally provide the name of the attribute
    [Parameter(
      Position = 0
    )]
    [string]$Name
  )
  begin {
    $ExcludedAttributes = @('CmdletBindingAttribute', 'OutputTypeAttribute')
    $commands = [ArrayList]::new()
  }
  process {
    if ($PSBoundParameters.ContainsKey('Rule')) {
      if ($Rule -is [string]) {
        try {
          $commands = Get-Command $Rule
        } catch {
          throw "There was an error finding command$Name`n$_"
        }
      } elseif ($Rule -is [CommandInfo]) {
        $commands = $Rule
      } else {
        throw "Cannot process $($Rule.GetType().FullName) as input for Rule"
      }
    } else {
      $module = $self.Module
      $module.ExportedCommands.Keys | ForEach-Object {
        [void]$commands.Add((Get-Command $_))
      }
    }

    foreach ($command in $commands) {
      $command.ScriptBlock.Attributes | Where-Object {
        $_.TypeId.Name -notin $ExcludedAttributes
      }
    }
  }
  end {}
}
