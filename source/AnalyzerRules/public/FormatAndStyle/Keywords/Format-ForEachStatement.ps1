
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-ForEachStatement {
  <#
  .SYNOPSIS
    Ensure the `foreach` and `in` keywords match the configured case.
  .DESCRIPTION
    Format the `foreach` and `in` keywords using UPPER, lower, or Capital case,
    according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.ForEachStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatIterationControl')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ForEachStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [ForEachStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(foreach)' = 'FormatIterationControl'
      }
    }
    Format-KeywordCase @options
  }
}
