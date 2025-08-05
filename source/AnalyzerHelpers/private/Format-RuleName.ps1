
function Format-RuleName {
  <#
    .SYNOPSIS
        Format the rule name based on the calling function
    .DESCRIPTION
      The main purpose of this function is to translate a function name in `Verb-Noun` format and return a "short
      name" that is appropriate for a block in the settings file. There are two verbs currently in use for rule
      function names:
      - Format
      : Functions that analyze the format and change the source code to conform to the rule
      - Measure
        : Functions that analyze the source for context.  These may or may not alter source code, but will warn when
        the rule is violated.
    .EXAMPLE

    #>
  [CmdletBinding()]
  param(
    # The name of the rule function (in Verb-Noun format)
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [string]$FunctionName
  )
  begin {
    Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
  }
  process {
    if ([string]::IsNullorEmpty($FunctionName)) {
      $callStack = Get-PSCallStack
      $FunctionName =  $callStack[0].FunctionName
    }
    # remove angle brackets if present
    $fullName = $FunctionName -replace '<(.*)>$', '$1'
    $verb, $noun = $fullName -split '-', 2

    switch -Regex ($verb) {
      '^Format' {
        # A rule function that is intended to format PowerShell source
        switch -Regex ($noun) {
          '^Place' {
            $shortName = $noun
          }
          default {
            $shortName = ($verb, $noun) -join ''
          }
        }
      }
      '^Measure' {
        switch ($noun) {
          default { $shortName = $noun }
        }
      }
    }

    [PSCustomObject]@{
      PSTypeName   = 'Analyzer.RuleName'
      FunctionName = $FunctionName
      ShortName    = $shortName
      Verb         = $verb
      Noun         = $noun
    }
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
  }
}
