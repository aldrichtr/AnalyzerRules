
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-CatchClause {
  <#
  .SYNOPSIS
    Ensure the `catch` keyword matches the configured case.
  .DESCRIPTION
    Format the `catch` keyword using UPPER, lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.CatchClauseAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatExceptionHandler')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [CatchClauseAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [CatchClauseAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(catch)' = 'FormatExceptionHandler'
      }
    }
    Format-KeywordCase @options
  }
}
