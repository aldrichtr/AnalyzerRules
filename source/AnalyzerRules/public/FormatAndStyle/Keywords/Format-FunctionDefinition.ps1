
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-FunctionDefinition {
  <#
  .SYNOPSIS
    Ensure `function` and `filter` keywords match the configured case.
  .DESCRIPTION
    Format the `function` and `filter` keywords using UPPER, lower, or Capital case,
    according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.FunctionDefinitionAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatTypeStructure')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [FunctionDefinitionAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [FunctionDefinitionAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(function|filter)' = 'FormatTypeStructure'
      }
    }
    Format-KeywordCase @options
  }
}
