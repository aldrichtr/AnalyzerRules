
function Split-Phrase {
  <#
 .SYNOPSIS
    Split a word or phrase into its parts
 .DESCRIPTION
    `Split-Phrase` wil split a phrase (words separated by space ' ' )or a word in:
    - camelCase
    - PascalCase
    - snake_case
    - kebab-case
    - dot.case
  .EXAMPLE
     PS> Split-Phrase 'thisIsCamelCase'

     this
     Is
     Camel
     Case
  .NOTES
     `Split-Phrase` will ignore the starting variable symbols ('$' or '@').  If
     the phrase could not be split, it will be returned as is,
     **with the exception that the preceding '$' or '@' is dropped.**
  #>
  [CmdletBinding()]
  [OutputType([string[]])]
  param(
    # The word to input
    [Parameter(
      ValueFromPipeline
    )]
    [string]$InputObject,

    # Digits are not allowed
    [Parameter(
    )]
    [switch]$DontAllowDigits
  )
  begin {
    $specialCharacters = @('$', '@')
    $splitPattern = (@(
        '(?<=[A-Z])(?=[A-Z][a-z])', # UC before me, UC lc after me
        '|(?<=[^A-Z])(?=[A-Z])', # Not UC before me, UC after me
        '|(?<=[A-Za-z])(?=[^A-Za-z])' # Letter before me, non-Letter after me
      ) -join '')
  }
  process {
    Write-Debug "The original phrase given is: '$InputObject'"
    if ($InputObject.Substring(0, 1) -in $specialCharacters) {
      #! Remove the first character
      Write-Debug 'The first character is special'
      $InputObject = $InputObject.Substring(1)
      Write-Debug "- phrase is now: '$InputObject'"
    }

    if ($InputObject.IndexOfAny(' ') -ge 0) {
      Write-Debug 'Phrase contains spaces'
      ($InputObject -split ' ')
    } elseif ( $InputObject | Test-CamelCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is camel case'
      (($InputObject -creplace $splitPattern, ' ') -split ' ')
    } elseif ( $InputObject | Test-PascalCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is pascal case'
      (($InputObject -creplace $splitPattern, ' ') -split ' ')
    } elseif ( $InputObject | Test-SnakeCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is snake case'
      ($InputObject -csplit '_')
    } elseif ( $InputObject | Test-KebabCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is kebab case'
      ($InputObject -csplit '-')
    } elseif ( $InputObject | Test-DotCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is dot case'
      ($InputObject -csplit '\.')
    } elseif ( $InputObject | Test-ConstantCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is constant case'
      ($InputObject -csplit '_')
    } elseif ( $InputObject | Test-TrainCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is train case'
      ($InputObject -csplit '-')
    } elseif ( $InputObject | Test-CobolCase -DontAllowDigits:$DontAllowDigits) {
      Write-Debug 'Phrase is cobol case'
      ($InputObject -csplit '-')
    } else {
      # if none of those worked, just return what we had to begin with
      #! unless there was a symbol at the start, which got removed
      Write-Debug 'No case found, returning phrase unchanged'
      $InputObject
    }
  }
  end {}
}