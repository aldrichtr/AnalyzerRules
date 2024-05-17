
using namespace System.Collections.ObjectModel
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

function Initialize-CorrectionCollection {
    <#
    .SYNOPSIS
        Create a new Collection of CorrectionExtent objects
    .EXAMPLE
        $corrections = Initialize-CorrectionCollection
    #>
    [CmdletBinding()]
    param(
    )
    [Collection[Generic.CorrectionExtent]]::new()
}
