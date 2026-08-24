
function ConvertTo-CamelCase {
  <#
  .SYNOPSIS
     Convert the given phrase to camelCase
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
      $phrase | Convert-Case capital -FirstWordCase lower
    }
  }
  end {}
}
