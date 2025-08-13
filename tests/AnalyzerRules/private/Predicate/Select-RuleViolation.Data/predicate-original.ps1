using namespace System.Management.Automation.Language
{
  param( [Parameter()][Ast]$Ast)
  $text = $Ast.Extent.Text
  if ($Ast -is [TrapStatementAst]) {
    $case = [StringCase]::Lower

    Write-Debug "Received AST $($Ast.GetType().FullName):"
    $null = $text -imatch '^(trap).*'
    if ($Matches.Count -gt 0) {
      $text = $Matches.1
    } else {
      Write-Debug "Something is wrong, TrapStatement did not start with 'trap'"
      return $false
    }
    Write-Debug "- with Text '$text'"
    switch ($case) {
      ([StringCase]::Lower) {
        Write-Debug '- Testing if $text is Lower case'
        return (-not ($text | Test-Case lower))
        continue
      }
      ([StringCase]::Upper) {
        Write-Debug '- Testing if $text is Upper case'
        return (-not ($text | Test-Case upper))
        continue
      }
      ([StringCase]::Capital) {
        Write-Debug '- Testing if $text is Capital case'
        return (-not ($text | Test-Case capital))
        continue
      }
      default {
        Write-Debug "Case was not set properly.  it is $case"
        return $false
      }
    }
  } else {
    return $false
  }
}
