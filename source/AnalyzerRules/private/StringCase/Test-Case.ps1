
using namespace System.Text

function Test-Case {
  <#
    .SYNOPSIS
        Returns true if the given string matches the parameters given
    #>
  [CmdletBinding(
    DefaultParameterSetName = 'default'
  )]
  param(
    # The phrase to be tested
    [Parameter(
      Mandatory,
      Position = 1,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [Alias('Name')]
    [string]$InputObject,

    # The case of the words in the phrase
    [Parameter(
      ParameterSetName = 'default',
      Mandatory,
      Position = 0
    )]
    [ValidateSet('lower', 'upper', 'capital', 'startLower', 'startUpper')]
    [string]$WordCase,

    # The case of the first word
    [Parameter(
      ParameterSetName = 'default'
    )]
    [ValidateSet('lower', 'upper', 'capital', 'startLower', 'startUpper')]
    [string]$FirstWordCase,

    # The separator character between words
    [Parameter(
      ParameterSetName = 'default'
    )]
    [AllowNull()]
    [AllowEmptyString()]
    [string]$Separator,

    # By the StringCase type enum
    [Parameter(
      ParameterSetName = 'ByType',
      position = 0
    )]
    [StringCase]$Type,

    # The number of consecutive uppercase letters
    # By default, only one upper
    [Parameter(
    )]
    [int]$ConsecutiveUppercase,

    # Digits are not allowed
    [Parameter(
    )]
    [switch]$DontAllowDigits
  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    $specialCharacters = @('$', '@', '#')
    $separatorCharacters = @('.', '-', '_')



    $pattern = [StringBuilder]::new()
    Set-Alias -Name 'getPattern' -Value Get-CasePattern -Scope Private
  }
  process {
    Write-Debug "Testing the case of string '$InputObject'"
    # SECTION Initialize tests
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

    # SECTION Handle variable identifiers

    if ($firstCharacter -in $specialCharacters) {
      Write-Debug "- Removing that $firstCharacter while processing, but we'll add it back to the output"
      [void]$newWord.Append($firstCharacter)
      $InputObject = $InputObject.Substring(1)
    }
    # !SECTION


    [void]$pattern.Append('^')

    $wordCasePattern = (getPattern $WordCase -DontAllowDigits:$DontAllowDigits)
    $remainingWordCasePattern = "($wordCasePattern)+"
    Write-Debug "Starting with pattern $($pattern.ToString())"


    if ($useFirstWord -and $useSeparator) {
      [void]$pattern.Append( (getPattern $FirstWordCase -DontAllowDigits:$DontAllowDigits) )
      [void]$pattern.Append($Separator)
    } elseif ($useFirstWord) {
      # Word has mixed-case, no separators
      [void]$pattern.Append( (getPattern $FirstWordCase -DontAllowDigits:$DontAllowDigits) )
      Write-Debug "- Adding FirstWordCase $($pattern.ToString())"
      [void]$pattern.Append($remainingWordCasePattern)
    } elseif ($useSeparator) {
      [void]$pattern.Append($wordCasePattern)
      [void]$pattern.Append("($Separator$wordCasePattern)*")
    } else {
      [void]$pattern.Append("($wordCasePattern)*")
    }

    [void]$pattern.Append('$')

    Write-Debug "Final Pattern: '$($pattern.ToString())'"
    $result = ($InputObject -cmatch $pattern.ToString())
    Write-Debug "- Result is $result"
    $result
  }
  end {
    Remove-Alias getPattern -Scope Private
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
