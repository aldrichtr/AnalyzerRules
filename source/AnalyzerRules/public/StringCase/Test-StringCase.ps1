
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
    )]
    [StringCase]$Case
    )
    begin {
      $self = $MyInvocation.MyCommand
        Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    }
    process {
      $testCmdName = 'Test-{0}Case' -f $Case.ToString()

      if ($self.Module.ExportedCommands.ContainsKey($testCmdName)) {
        & $testCmdName @('-InputObject', $InputObject)
      }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
