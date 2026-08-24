
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-DoUntilStatement {
  <#
  .SYNOPSIS
    Ensure `do` and `until` keywords in do/until loops match the configured case.
  .DESCRIPTION
    Format the `do` and `until` keywords in do/until loops using UPPER, lower, or Capital case,
    according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.DoUntilStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatIterationControl')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [DoUntilStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [DoUntilStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(do)' = 'FormatIterationControl'
      }
    }
    Format-KeywordCase @options
  }
}
