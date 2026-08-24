
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-ForStatement {
  <#
  .SYNOPSIS
    Ensure the `for` keyword matches the configured case.
  .DESCRIPTION
    Format the `for` keyword using UPPER, lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.ForStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatIterationControl')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ForStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [ForStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(for)' = 'FormatIterationControl'
      }
    }
    Format-KeywordCase @options
  }
}
