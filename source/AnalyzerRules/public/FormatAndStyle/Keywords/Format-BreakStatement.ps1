
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-BreakStatement {
  <#
  .SYNOPSIS
    Ensure the `break` keyword matches the configured case.
  .DESCRIPTION
    Format the `break` keyword using UPPER, lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.BreakStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatBranchingStatement')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [BreakStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [BreakStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(break)' = 'FormatBranchingStatement'
      }
    }
    Format-KeywordCase @options
  }
}
