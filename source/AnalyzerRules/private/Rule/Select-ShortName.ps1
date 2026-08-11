
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
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
  }
  process {
     Format-Rulename @PSBoundParameters |
       Select-Object -ExpandProperty ShortName
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
