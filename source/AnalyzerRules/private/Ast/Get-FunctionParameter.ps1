
using namespace System.Management.Automation.Language

function Get-FunctionParameter {
  <#
  .SYNOPSIS
    Return the Parameters defined in the given Function
  #>
  [CmdletBinding()]
  param(
    # The FunctionDefinitionAst
    [Parameter(
      ValueFromPipeline
    )]
    [FunctionDefinitionAst]$InputAst
  )
  process {
    $InputAst.Body.ParamBlock.Parameters |
    ForEach-Object { $_.Name.VariablePath.UserPath }
  }
}
