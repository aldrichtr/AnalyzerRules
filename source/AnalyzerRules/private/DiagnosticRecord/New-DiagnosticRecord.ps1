
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-DiagnosticRecord {
  <#
  .SYNOPSIS
     Create a new DiagnosticRecord
  #>
  [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseShouldProcessForStateChangingFunctions', '',
    Justification = 'Function does not change system state')]
  [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord])]
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
    [System.Management.Automation.Language.IScriptExtent]$Extent,

    # The severity level of the issue
    [Parameter()]
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]$Severity,

    # Path to the script file
    [Parameter()]
    [string]$ScriptPath,

    # Why this record was created
    [Parameter( ValueFromPipelineByPropertyName)]
    [string]$Message,

    # Suggested correction to the extent
    [Parameter()]
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent[]]$SuggestedCorrections
  )
  begin {}
  process {
    if (-not ($PSBoundParameters.ContainsKey('RuleSuppressionId'))) {
      $PSBoundParameters['RuleSuppressionId'] = $RuleName
    }

    if (-not ($PSBoundParameters.ContainsKey('Severity'))) {
      $PSBoundParameters['Severity'] = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning
    }
    if ($PSBoundParameters.ContainsKey('SuggestedCorrections')) {
      $corrections = New-CorrectionCollection
      foreach ($c in $SuggestedCorrections) {
        [void]$corrections.Add($c)
      }
      $PSBoundParameters['SuggestedCorrections'] = $corrections
    }
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]$PSBoundParameters
  }
  end {}
}
