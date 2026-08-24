
function Test-CobolCase {
  <#
  .SYNOPSIS
    Return true if the given string is COBOL-CASE (all words uppercase, hyphen separator)
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
    $options = @{
      WordCase        = 'upper'
      Separator       = '-'
      DontAllowDigits = $DontAllowDigits
    }
    $InputObject | Test-Case @options
  }
  end {}
}
