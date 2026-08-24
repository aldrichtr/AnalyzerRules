
function Test-StringCase {
  <#
  .SYNOPSIS
     Return true if the given string matches the given Case
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

    # The case of the input
    [Parameter(
      Position = 0
    )]
    [StringCase]$Case
  )
  begin {}
  process {
    $testCmdName = 'Test-{0}Case' -f $Case.ToString()

    if ($self.Module.ExportedCommands.ContainsKey($testCmdName)) {
      & $testCmdName @('-InputObject', $InputObject)
    }
  }
  end {}
}
