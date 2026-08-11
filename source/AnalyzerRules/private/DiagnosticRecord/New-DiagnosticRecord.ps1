
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-DiagnosticRecord {
  <#
    .SYNOPSIS
        Create a new DiagnosticRecord
    #>
  [CmdletBinding()]
  param(
    # The name of the PSSA Rule
    [Parameter(
      Mandatory
    )]
    [string]$RuleName,

    # The rule ID for this record if different than the `RuleName`
    [Parameter()]
    [string]$RuleSuppressionId,

    # A span of text in the script
    [Parameter( ValueFromPipelineByPropertyName)]
    [IScriptExtent]$Extent,

    # The severity level of the issue
    [Parameter()]
    [DiagnosticSeverity]$Severity,

    # Path to the script file
    [Parameter()]
    [string]$ScriptPath,

    # Why this record was created
    [Parameter( ValueFromPipelineByPropertyName)]
    [string]$Message,

    # Suggested correction to the extent
    [Parameter()]
    [CorrectionExtent[]]$SuggestedCorrections
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
  }
  process {
    if (-not ($PSBoundParameters.ContainsKey('RuleSuppressionId'))) {
      $PSBoundParameters['RuleSuppressionId'] = $RuleName
    }

    if (-not ($PSBoundParameters.ContainsKey('Severity'))) {
      $PSBoundParameters['Severity'] = [DiagnosticSeverity]::Warning
    }
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
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
