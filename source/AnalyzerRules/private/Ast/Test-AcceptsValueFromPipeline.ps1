
using namespace System.Management.Automation.Language

function Test-AcceptsValueFromPipeline {
  [OutputType([System.Boolean])]
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ParameterAst] $ParameterAst
  )

  :attribute foreach ($attribute in $ParameterAst.Attributes) {
    if ($attribute.TypeName.FullName -ne 'Parameter') { continue attribute }

    foreach ($namedArgument in $attribute.NamedArguments) {
      if ($namedArgument.ArgumentName -eq 'ValueFromPipeline') {
        return $true
      }
    }
  }
  return $false
}
