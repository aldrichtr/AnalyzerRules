
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
            [List[DiagnosticRecord]]::new()
}
