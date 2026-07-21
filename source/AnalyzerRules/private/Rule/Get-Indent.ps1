
using namespace System.Collections
function Get-Indent {
  <#
  .SYNOPSIS
    In the given block of text, get the leading whitespace for the given line.
  #>
  [CmdletBinding( DefaultParameterSetName = 'AsText')]
  param(
    # The block of text to search through
    [Parameter(
      Position = 1,
      ValueFromPipeline
    )]
    [string[]]$Extent,

    # The text of the line to get the indent from.  Uses the first line of input if not given
    [Parameter(
      ParameterSetName = 'AsText',
      Position = 0
    )]
    [AllowEmptyString()]
    [string]$AtText,

    # The index of the line to get the indent from.
    [Parameter(
      ParameterSetName = 'AsIndex',
      Position = 0
    )]
    [Int]$Index

  )
  begin {
    $self = $MyInvocation.MyCommand
    Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    $collect = [ArrayList]::new()
    $indentPattern = '^(?<indent>[ \t]*)'
  }
  process {
    $Extent -split '\n' |
      ForEach-Object { [void]$collect.Add($_) }
  }
  end {
    $result = ''
    if ($PSCmdlet.ParameterSetName -like 'AsIndex') {
      if ($Index -lt $collect.Count) {
        $null = $collect[$Index] -match $indentPattern
        $result = $Matches.indent ?? ''
      } else {
        throw "Input is only $($collect.Count) lines. $Index is out of range"
      }
    } elseif ($PSCmdlet.ParameterSetName -like 'AsText') {
      :line foreach ($line in $collect) {
        $matcher = "$indentPattern$([regex]::Escape($Text))"
        if ($line -match $matcher) {
          $result = $Matches.indent
          break line
        }
      }
    } else {
      $null = $collect[0] -match $indentPattern
      $result = $Matches.indent ?? ''
    }
    $result
    Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
  }
}
