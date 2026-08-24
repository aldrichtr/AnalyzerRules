
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-Correction {
  <#
  .SYNOPSIS
     Create a new PSSA Correction
  #>
  [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseShouldProcessForStateChangingFunctions', '',
    Justification = 'Function does not change system state')]
  [OutputType([CorrectionExtent])]
  [CmdletBinding()]
  param(
    # SECTION Line numbers
    # Starting line number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$StartLineNumber,

    # Ending line number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$EndLineNumber,
    # !SECTION

    # SECTION Column numbers
    # Starting Column number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$StartColumnNumber,

    # Ending Column number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$EndColumnNumber,
    # !SECTION

    # The text to replace with
    [Parameter( ValueFromPipelineByPropertyName)]
    [string]$ReplacementText,

    # Path to the file
    [Parameter( ValueFromPipelineByPropertyName)]
    [Alias('File')]
    [string]$Path,

    # Description of the correction
    [Parameter( ValueFromPipelineByPropertyName)]
    [string]$Description
  )

  begin {}
  process {
    (@(
      'Creating the correction:',
      ('At {0}:L{1}C{2} to L{3}C{4}' -f @(
        ($Path ?? 'ScriptBlock'),
        $StartLineNumber,
        $StartColumnNumber,
        $EndLineNumber,
        $EndColumnNumber)),
      "With '$ReplacementText'",
      "Description: '$Description'" -join "`n")) | Write-Debug
    try {

      $correction = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent]::new(
        $StartLineNumber,
        $EndLineNumber,
        $StartColumnNumber,
        $EndColumnNumber,
        $ReplacementText,
        $Path,
        $Description)
    } catch {
      throw "Could not create Correction`n$_"
    }
    if ($null -ne $correction) {
      Write-Debug 'Successfully created CorrectionExtent'
      $correction
    } else {
      throw 'No correction was created.'
    }
  }
  end {}
}
