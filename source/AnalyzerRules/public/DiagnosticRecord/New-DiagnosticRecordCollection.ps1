
using namespace System.Collections.Generic
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-DiagnosticRecordCollection {
  <#
    .SYNOPSIS
        Create a new collection for holding DiagnosticRecords
    #>
  [CmdletBinding()]
  [OutputType([List[DiagnosticRecord]])]
  param(
  )
  [List[DiagnosticRecord]]::new()
}
