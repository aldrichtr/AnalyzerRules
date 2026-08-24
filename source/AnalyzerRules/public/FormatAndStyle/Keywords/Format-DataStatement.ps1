
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-DataStatement {
  <#
  .SYNOPSIS
    Ensure the `data` keyword matches the configured case.
  .DESCRIPTION
    Format the `data` keyword using UPPER, lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.DataStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatNamedBlock')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [DataStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [DataStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(data)' = 'FormatNamedBlock'
      }
    }
    Format-KeywordCase @options
  }
}
