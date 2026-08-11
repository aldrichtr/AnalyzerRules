
using namespace System.Text
using namespace System.Collections

function Convert-Case {
  <#
.SYNOPSIS
  Convert the given string from its current case to the one given
.DESCRIPTION
  Co
  #>
  [CmdletBinding()]
  param(
    # The phrase to convert
    [Parameter(
      Mandatory,
      Position = 1,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [Alias('Name')]
    [string]$InputObject,

    # The case of the first word
    [Parameter(
    )]
    [ValidateSet('lower', 'upper', 'capital')]
    [string]$FirstWordCase,

    # The case of the words in the phrase
    [Parameter(
      Mandatory,
      Position = 0
    )]
    [ValidateSet('lower', 'upper', 'capital')]
    [string]$WordCase,

    # The separator character between words
    [Parameter(
    )]
    [AllowNull()]
    [AllowEmptyString()]
    [string]$Separator
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    $specialCharacters = @('$', '@', '#')
    $separatorCharacters = @('.', '-', '_')

    $newWord = [StringBuilder]::new()
    $textInfo = (Get-Culture).TextInfo
    $parts = [ArrayList]::new()
  }
  process {
    Write-Debug "Converting the case of string '$InputObject'"
    # SECTION
    $useSeparator = ($PSBoundParameters.ContainsKey('Separator'))
    $useFirstWord = ($PSBoundParameters.ContainsKey('FirstWordCase'))
    $useOneCase   = ((-not $useSeparator) -and (-not $useFirstWord))
    $containsSpaces = ($InputObject.IndexOf(' ') -ge 0)
    $firstCharacter = $InputObject.Substring(0, 1)
    $containsSeparators = $false

    foreach ($sep in $separatorCharacters) {
      if ($InputObject.IndexOfAny($separatorCharacters) -ge 0) {
        $containsSeparators = $true
      }
    }
    # !SECTION

    # NOTE: If the phrase starts with a special character, take it off the input,
    #!! but add it back onto the output

    if ($firstCharacter -in $specialCharacters) {
      Write-Debug "- Removing that $firstCharacter while processing, but we'll add it back to the output"
      [void]$newWord.Append($firstCharacter)
      $InputObject = $InputObject.Substring(1)
    }

    if ($useOneCase -and (-not $containsSpaces) -and (-not $containsSeparators)) {
      Write-Debug "- $InputObject is a single word phrase"
      [void]$parts.Add($InputObject)
   } else {
      ($InputObject | Split-Phrase) | ForEach-Object { [void]$parts.Add($_) }
      Write-Debug "- Converting complex case.  Splitting phrase into $($parts.Count) parts"

      if ($useFirstWord) {
        Write-Debug "  - Starting with the first word '$($parts[0])' to $FirstWordCase"
        switch ($FirstWordCase) {
          'upper' {
            [void]$newWord.Append( $textInfo.ToUpper($parts[0]))
            continue
          }
          'lower' {
            [void]$newWord.Append( $textInfo.ToLower($parts[0]))
            continue
          }
          'capital' {
            [void]$newWord.Append( $textInfo.ToTitleCase($parts[0]))
            continue
          }
          default {
            throw "First word case set to $FirstWordCase, which is not a valid case"
          }
        }
        [void]$parts.RemoveAt(0)
        Write-Debug "- Converted word is $($newWord.ToString()) so far"
      }
    }

    Write-Debug "- Converting remaining input to $WordCase case"
    switch ($WordCase) {
      'upper' {
        [void]$newWord.Append( ($textInfo.ToUpper($parts) -replace ' ', ($Separator ?? '')))
        continue
      }
      'lower' {
        [void]$newWord.Append( ($textInfo.ToLower($parts) -replace ' ', ($Separator ?? '')))
        continue
      }
      'capital' {
        [void]$newWord.Append( ($textInfo.ToTitleCase($parts) -replace ' ', ($Separator ?? '')))
        continue
      }
      default {
        throw "Word case set to $WordCase, which is not a valid case"
      }
    }
    Write-Debug "Completed conversion: Now phrase is '$($newWord.ToString())'"
    $newWord.ToString()
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
