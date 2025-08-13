
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function New-Correction {
  <#
    .SYNOPSIS
        Create a new PSSA Correction
    #>
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

    # SECTION Offset
    # Starting Offset number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$StartOffsetNumber,

    # Ending Offset number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$EndOffsetNumber,
    # !SECTION Offset

    # SECTION ScriptPosition
    # Starting ScriptPosition number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$StartScriptPositionNumber,

    # Ending ScriptPosition number
    [Parameter( ValueFromPipelineByPropertyName)]
    [int]$EndScriptPositionNumber,
    # !SECTION ScriptPosition

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

  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
  }
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

      $correction = [CorrectionExtent]::new(
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
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
