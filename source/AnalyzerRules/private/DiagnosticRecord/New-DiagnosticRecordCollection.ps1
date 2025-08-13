
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
  begin {
      $self = $MyInvocation.MyCommand
      Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
  }
  process {
     try {
       $collection = [List[DiagnosticRecord]]::new()
     }
     catch {
      throw "Could not create results collection`n$_ "
     }
     if ($null -ne $collection) {
       Write-Output $collection -NoEnumerate
     } else {
      throw "No results collection was created"
     }
  }
  end {
      Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
