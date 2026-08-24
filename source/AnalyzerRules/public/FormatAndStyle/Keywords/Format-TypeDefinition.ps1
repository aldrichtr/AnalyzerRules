
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-TypeDefinition {
  <#
  .SYNOPSIS
    Ensure `enum` and `class` keywords match the configured case.
  .DESCRIPTION
    Format the `enum` and `class` keywords using UPPER, lower, or Capital case,
    according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.TypeDefinitionAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatTypeStructure')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [TypeDefinitionAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [TypeDefinitionAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(enum|class)' = 'FormatTypeStructure'
      }
    }
    Format-KeywordCase @options
  }
}
