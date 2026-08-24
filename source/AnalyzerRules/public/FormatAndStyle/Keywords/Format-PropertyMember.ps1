
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-PropertyMember {
  <#
  .SYNOPSIS
    Ensure `static` and `hidden` keywords on property members match the configured case.
  .DESCRIPTION
    Format the `static` and `hidden` keywords on class property declarations using UPPER,
    lower, or Capital case, according to the `Case` setting.
  .INPUTS
    [System.Management.Automation.Language.PropertyMemberAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatVisibility')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [PropertyMemberAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [PropertyMemberAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '\b(static|hidden)\b' = 'FormatVisibility'
      }
    }
    Format-KeywordCase @options
  }
}
