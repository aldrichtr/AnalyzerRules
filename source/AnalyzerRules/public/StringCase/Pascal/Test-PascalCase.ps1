
function Test-PascalCase {
  <#
  .SYNOPSIS
    Return true if the given string is PascalCase (all words capitalized, no separator)
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
      WordCase        = 'capital'
      DontAllowDigits = $DontAllowDigits
    }
    $InputObject | Test-Case @options
  }
  end {}
}
