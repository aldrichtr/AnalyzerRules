
<# !REVIEW
The reason i started this was so that I could get the custom attributes added to the rule functions.
But I am trying to build too much into this one function i think.  I want:
- All of the (custom) attributes assigned to a given function
- Just the given attribute from the given function

But then I started thinking that Get-RuleAttribute might go up to the module,
get all commands, and then list all attributes, that is idiomatic for a Get command
The issue is on the returned content.  Do I return the rule attributes
#>
using namespace System.Collections
using namespace System.Management.Automation

function Get-RuleAttribute {
  <#
   # .SYNOPSIS
   #    Get the Attributes associated with the given rule function
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
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
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
      $command.ScriptBlock.Attributes
      | Where-Object {
        $_.TypeId.Name -notin $ExcludedAttributes
      }
    }

  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
