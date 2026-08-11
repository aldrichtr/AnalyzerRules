
using namespace System.Collections.ObjectModel
using namespace System.Collections.Generic
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic
function New-CorrectionCollection {
  <#
    .SYNOPSIS
        Create a new Collection of CorrectionExtent objects
    .EXAMPLE
        $corrections = New-CorrectionCollection
    #>
  [OutputType([Collection[CorrectionExtent]])]
  [CmdletBinding()]
  param(
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
  }
  process {
    try {
      $collection = [Collection[CorrectionExtent]]::new()
    } catch {
      throw "Could not create collection`n$_"
    }
    if ($null -ne $collection) {
      Write-Output $collection -NoEnumerate
    } else {
      throw 'No collection was created'
    }
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
