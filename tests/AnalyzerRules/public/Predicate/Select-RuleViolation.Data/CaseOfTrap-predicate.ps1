{
  param(
    [Parameter()][Ast]$Ast
  )
  Write-Debug "Received AST: $($Ast.GetType().FullName)"
  $case = [StringCase]::Upper
  $text = $Ast.Extent.Text
  if (($Ast -is [TrapStatementAst]) -and
    ($text -imatch '^trap')) {
    Write-Debug "Validating case of '$text'"
    switch ($case) {
      ([StringCase]::Lower) {
        return ($text | Test-Case lower)
      }
      ([StringCase]::Upper) {
        return ($text | Test-Case upper)
      }
      ([StringCase]::Capital) {
        return ($text | Test-Case capital)
      }
    }
  }
}
