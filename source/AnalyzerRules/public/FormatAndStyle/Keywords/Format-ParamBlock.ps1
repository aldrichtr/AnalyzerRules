
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-ParamBlock {
  <#
  .SYNOPSIS
    Ensure the `param` keyword matches the configured case.
  .DESCRIPTION
    Format the `param` keyword using UPPER, lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.ParamBlockAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatParameterKeyword')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ParamBlockAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [ParamBlockAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(param)' = 'FormatParameterKeyword'
      }
    }
    Format-KeywordCase @options
  }
}
