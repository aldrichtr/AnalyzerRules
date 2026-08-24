
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-FunctionMember {
  <#
  .SYNOPSIS
    Ensure `static` and `hidden` keywords on class method members match the configured case.
  .DESCRIPTION
    Format the `static` and `hidden` keywords on class method declarations using UPPER,
    lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.FunctionMemberAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatVisibility')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [FunctionMemberAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [FunctionMemberAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '\b(static|hidden)\b' = 'FormatVisibility'
      }
    }
    Format-KeywordCase @options
  }
}
