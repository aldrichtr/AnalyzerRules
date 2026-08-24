
using namespace System.Collections.ObjectModel
using namespace System.Collections.Generic
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
function New-CorrectionCollection {
  <#
  .SYNOPSIS
     Create a new Collection of CorrectionExtent objects
  .EXAMPLE
     PS> $corrections = New-CorrectionCollection
  #>
  [OutputType([System.Collections.ObjectModel.Collection[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent]])]
  [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseShouldProcessForStateChangingFunctions', '',
    Justification = 'Function does not change system state')]
  [CmdletBinding()]
  param()
  try {
    $collection = [System.Collections.ObjectModel.Collection[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent]]::new()
  } catch {
    throw "Could not create collection`n$_"
  }
  if ($null -ne $collection) {
    Write-Output $collection -NoEnumerate
  } else {
    throw 'No collection was created'
  }
}
