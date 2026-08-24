
function ConvertTo-SnakeCase {
  <#
  .SYNOPSIS
     Convert the given phrase to snake_case
  .DESCRIPTION
     In snake case, each word is lowercase, and they are separated by an underscore '_'
     - usb_port
     - remaining_values_in_collection
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
      $phrase | Convert-Case lower -Separator '_'
    }
  }
  end {}
}