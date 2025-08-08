
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-DiagnosticRecord {
    <#
    .SYNOPSIS
        Create a new DiagnosticRecord
    #>
    [CmdletBinding()]
    param(
        # Why this record was created
        [Parameter( ValueFromPipelineByPropertyName)]
        [string]$Message,

        # A span of text in the script
        [Parameter( ValueFromPipelineByPropertyName)]
        [ScriptExtent]$Extent,

        # The name of the PSSA Rule
        [Parameter()]
        [string]$RuleName,

        # The severity level of the issue
        [Parameter()]
        [DiagnosticSeverity]$Severity,

        # Path to the script file
        [Parameter()]
        [string]$ScriptPath,

        # The rule ID for this record
        [Parameter()]
        [string]$SuppressionId,

        # Suggested correction to the extent
        [Parameter()]
        [CorrectionExtent[]]$SuggestedCorrections
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        <#------------------------------------------------------------------
          ! Convert a list of CorrectionExtents into an ObjectModel collection
          before creating the Diagnostic Record
        ------------------------------------------------------------------#>
        if ($PSBoundParameters.ContainsKey('SuggestedCorrections')) {
            $corrections = New-CorrectionCollection
            foreach ($c in $SuggestedCorrections) {
                [void]$corrections.Add($c)
            }
            $PSBoundParameters['SuggestedCorrections'] = $corrections
        }
        [DiagnosticRecord]$PSBoundParameters
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
