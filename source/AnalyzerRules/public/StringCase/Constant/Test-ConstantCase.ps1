
function Test-ConstantCase {
  <#
  .SYNOPSIS
    Return true if the given string is CONSTANT_CASE (all words uppercase, underscore separator)
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
      Separator       = '_'
      DontAllowDigits = $DontAllowDigits
    }
    $InputObject | Test-Case @options
  }
  end {}
}
