
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-TrapStatement {
  <#
  .SYNOPSIS
    Ensure the `trap` keyword is the case given in the `FormatTrapStatement` setting.
  .DESCRIPTION
    Format the `trap` keyword using UPPER, lower, or Capital case, according to the `Case` setting. This rule
    is part of the `FormatKeyword` category.  Settings for `FormatTrapStatement` and `FormatKeyword` are both
    evaluated.  See details in the docs under *Settings that affect rules*
  .INPUTS
    [System.Management.Automation.Language.TrapStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatExceptionHandler')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [TrapStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [TrapStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '(trap)' = 'FormatExceptionHandler'
      }
    }
    Format-KeywordCase @options
  }
}