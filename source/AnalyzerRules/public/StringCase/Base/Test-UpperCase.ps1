
function Test-UpperCase {
  <#
  .SYNOPSIS
    Return true if the given word is Capitalized
  #>
  [CmdletBinding()]
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

    # Digits are not allowed
    [Parameter(
    )]
    [switch]$DontAllowDigits
  )
  process {
    $pattern = Get-CasePattern -Case upper -DontAllowDigits:$DontAllowDigits
    ($InputObject -cmatch $pattern)
  }
}
