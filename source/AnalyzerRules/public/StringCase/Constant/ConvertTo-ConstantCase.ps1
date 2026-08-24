
function ConvertTo-ConstantCase {
  <#
  .SYNOPSIS
     Convert the given phrase to CONSTANT_CASE
  #>
  [CmdletBinding()]
  param(
    # The phrase to be converted
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
      $phrase | Convert-Case upper -Separator '_'
    }
  }
  end {}
}
