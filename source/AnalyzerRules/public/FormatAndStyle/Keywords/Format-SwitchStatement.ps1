
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-SwitchStatement {
  <#
  .SYNOPSIS
    Ensure the `switch` keyword matches the configured case.
  .DESCRIPTION
    Format the `switch` keyword using UPPER, lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.SwitchStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatConditional')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [SwitchStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [SwitchStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(switch)' = 'FormatConditional'
      }
    }
    Format-KeywordCase @options
  }
}
