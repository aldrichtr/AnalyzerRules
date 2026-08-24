
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-NamedBlock {
  <#
  .SYNOPSIS
    Ensure Named script blocks are in the case given in the FormatNamedBlock setting.
  .DESCRIPTION
    Format the case of named blocks in a function (`begin`, `process`, `end`, `clean`)
    and parameter keywords (`dynamicparam`).
  .NOTES
    There are three types of 'case' settings that can be configured in the Settings file under FormatNamedBlock,
    `lower`, `upper`, `capital`
    ```powershell
    Rules = @{
      FormatNamedBlock = @{
         Enabled = $true
         Case = 'lower'
      }
    }
    ```
  .INPUTS
    [System.Management.Automation.Language.NamedBlockAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [NamedBlockAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [NamedBlockAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(begin|process|end|clean)' = 'FormatNamedBlock'
        '^(dynamicparam)'            = 'FormatParameterKeyword'
      }
    }
    Format-KeywordCase @options
  }
}