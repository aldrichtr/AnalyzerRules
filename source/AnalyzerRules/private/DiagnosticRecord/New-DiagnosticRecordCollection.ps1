
using namespace System.Collections.Generic
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-DiagnosticRecordCollection {
  <#
  .SYNOPSIS
     Create a new collection for holding DiagnosticRecords
  #>
  [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseShouldProcessForStateChangingFunctions', '',
    Justification = 'Function does not change system state')]
  [CmdletBinding()]
  param()
  try {
    $collection = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
  } catch {
    throw "Could not create DiagnosticRecord collection. Is PSScriptAnalyzer loaded?`n$_"
  }
  if ($null -eq $collection) { throw 'DiagnosticRecord collection was not created' }
  $collection
}
