
function Test-CapitalCase {
  <#
  .SYNOPSIS
    Return true if the given word is all lowercase
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
  begin {}
  process {
    $pattern = Get-CasePattern -Case capital -DontAllowDigits:$DontAllowDigits
    ($InputObject -cmatch $pattern)
  }
  end {}
}