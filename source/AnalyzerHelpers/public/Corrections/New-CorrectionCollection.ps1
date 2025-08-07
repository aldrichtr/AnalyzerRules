
using namespace System.Collections.ObjectModel
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
    [Collection[CorrectionExtent]]::new()
}
