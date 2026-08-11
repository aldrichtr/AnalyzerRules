
function Resolve-ProjectRoot {
  [CmdletBinding()]
  param()
  $top = & 'git' @('rev-parse', '--show-toplevel')

  if ($null -ne $top) {
    Get-Item $top
  }
}

function Select-IsolatedRule {
  <#
  .SYNOPSIS
    Return a ScriptAnalyzer Settings table with the given rule enabled
  #>
  [CmdletBinding()]
  param(
    # The name of the rule to enable
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [string]$RuleName
  )

  @{
    Severity = @('Information', 'Warning', 'Error')
    IncludeDefaultRules = $false

    CustomRulesPath = (Join-Path (Resolve-ProjectRoot) "source" "AnalyzerRules")
    RecurseCustomRulesPath = $true

    IncludeRules = $RuleName
  }
}
