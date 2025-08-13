
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
    .NOTES
      - Format-LanguageComponent => FormatLanguageComponent
      - Format-PlaceSquareBracket => PlaceSquareBracket   ! the word Place is significant
      - Measure-LanguageComponent => LanguageComponent
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
    Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
  }
  process {
    if ([string]::IsNullorEmpty($Name)) {
      Write-Debug 'No Name given.  Looking at Caller info'
      $callStack = Get-PSCallStack
      $Name =  $callStack[1].Name
      Write-Debug "Callers name is $Name"
    }

    <#
      When we get the caller's name, it might come back with a <NamedBlock> (Begin, Process, End) on the end, so we
      want to remove that and then split on the '-' in a Verb-Noun style Function
    #>
    $fullName = $Name -replace '<.*>$', ''
    $verb, $noun = $fullName -split '-', 2

    Write-Debug "- Verb: $verb , Noun: $noun"
    switch -Regex ($verb) {
      '^Format' {
        switch -Regex ($noun) {
          '^Place' {
            $shortName = $noun
          }
          default {
            $shortName = @($verb, $noun) -join ''
          }
        }
      }
      '^Measure' {
        switch ($noun) {
          default { $shortName = $noun }
        }
      }
      default {
        $shortName = @($verb, $noun) -join ''
      }
    }
    Write-Debug "Short name set to: $shortName"

    [PSCustomObject]@{
      PSTypeName = 'Analyzer.RuleName'
      Name       = $Name
      ShortName  = $shortName
      Verb       = $verb
      Noun       = $noun
    }
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
  }
}
