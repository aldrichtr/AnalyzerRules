
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
using namespace System.Management.Automation.Language

function Format-TryStatement {
  <#
  .SYNOPSIS
    Ensure try/finally keywords are in the case given in the FormatTryStatement setting.
  .DESCRIPTION
    Format the case of try statement keywords (`try`, `finally`).
  .NOTES
    There are three types of 'case' settings that can be configured in the Settings
    file under FormatTryStatement:
    `lower`, `upper`, `capital`
    ```powershell
    Rules = @{
      FormatTryStatement = @{
         Enabled = $true
         Case = 'lower'
      }
    }
    ```
  .INPUTS
    [System.Management.Automation.Language.TryStatementAst]
  .OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
  #>
  [RuleCategory('FormatKeyword')]
  [RuleCategory('FormatExceptionHandler')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [TryStatementAst]$InputAst
  )
  process {
    $options = @{
      InputAst      = $InputAst
      AstType       = [TryStatementAst]
      CallerCommand = $MyInvocation.MyCommand
      KeywordMap    = @{
        '^(try|finally)' = 'FormatExceptionHandler'
      }
    }
    Format-KeywordCase @options
  }
}