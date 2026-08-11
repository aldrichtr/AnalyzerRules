
using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'Predicate', 'Select', 'RuleViolation')
  Name    = 'given the private function Select-RuleViolation'
  Foreach = $dataDirectory
}
Describe @options {
    BeforeAll {
      $dataDirectory = $_
    }

  <# --=-- #>
  Context 'WHEN given an AST and a predicate' -ForEach @(
    @{ Name = 'CaseOfTrap' }
  ) {
    BeforeAll {
      $predicateFile = (Join-Path $dataDirectory "$Name-predicate.ps1")
      $scriptBlockFile = (Join-Path $dataDirectory "$Name-scriptblock.ps1")

      if ($predicateFile | Test-Path) {
        $predicate = [scriptblock]::Create((Get-Content $predicateFile -Raw))
      } else {
        throw "$predicateFile is not a valid path"
      }

      if ($scriptBlockFile | Test-Path) {
        $scriptBlockAst = Get-Item $scriptBlockFile | ConvertTo-Ast
      } else {
        throw "$scriptBlockFile is not a valid path"
      }

      $result = $scriptBlockAst | Select-RuleViolation -Filter $predicate -Recurse
    }

    It 'The script block ast should be an AST object' {
      $scriptBlockAst | Should -BeOfType [System.Management.Automation.Language.Ast]
    }
    It 'It should return a result' {
      $result | Should -Not -BeNullOrEmpty
    }

    It 'It should return an Ast Object' {
      $result | Should -BeOfType [System.Management.Automation.Language.Ast]
    }
  }
  <# --=-- #>
}
