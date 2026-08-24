
function Select-ShortName {
  <#
  .SYNOPSIS
    Return the short name of the given rule
  #>
  [CmdletBinding()]
  param(
    # The name of the rule function (in Verb-Noun format)
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [string]$Name
  )
  begin {}
  process {
    Format-Rulename @PSBoundParameters |
      Select-Object -ExpandProperty ShortName
  }
  end {}
}
