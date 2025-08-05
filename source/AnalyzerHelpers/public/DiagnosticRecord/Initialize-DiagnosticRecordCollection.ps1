
using namespace System.Collections.Generic
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function Initialize-DiagnosticRecordCollection {
    <#
    .SYNOPSIS
        Create a new collection for holding DiagnosticRecords
    #>
    [Alias('New-ResultsCollection')]
    [CmdletBinding()]
    [OutputType([List[DiagnosticRecord]])]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
      # TODO: If the only thing this function does is create the list, then it is probably not needed
        try {
            $list = [List[DiagnosticRecord]]::new()
            if ($null -ne $list) {
                $list
            }
        } catch {
            throw "Could not create DiagnosticRecord collection`n$_"
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
