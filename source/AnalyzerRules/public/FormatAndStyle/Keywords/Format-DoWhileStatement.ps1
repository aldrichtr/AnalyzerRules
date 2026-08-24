
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-DoWhileStatement {
  <#
  .SYNOPSIS
    Ensure `do` and `while` keywords in do/while loops match the configured case.
  .DESCRIPTION
    Format the `do` and `while` keywords in do/while loops using UPPER, lower, or Capital case,
    according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.DoWhileStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatIterationControl')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [DoWhileStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [DoWhileStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(do)' = 'FormatIterationControl'
      }
    }
    Format-KeywordCase @options
  }
}
