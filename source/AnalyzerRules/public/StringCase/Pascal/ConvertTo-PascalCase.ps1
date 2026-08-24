
function ConvertTo-PascalCase {
  <#
  .SYNOPSIS
     Convert the given phrase to PascalCase
  #>
  [CmdletBinding()]
  param(
    # The phrase to convert
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [Alias('Name')]
    [string[]]$InputObject
  )
  begin {}
  process {
    foreach ($phrase in $InputObject) {
      $phrase | Convert-Case capital
    }
  }
  end {}
}