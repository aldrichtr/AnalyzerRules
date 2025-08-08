using namespace System.Management.Automation.Language

BeforeDiscovery {
  $sourceFile = Get-SourceFilePath $PSCommandPath

  if (-not (Test-Path $sourceFile)) {
    throw "Could not find $sourceFile from $PSCommandPath"
  }

  $analyzerRules = Get-ScriptAnalyzerRule -Severity Error, Warning
  | Where-Object {
    $_.RuleName -notmatch '(^PSDSC)|Manifest'
  }

  try {
    $analysis = Invoke-ScriptAnalyzer -Path $sourceFile -IncludeRule $analyzerRules
  } catch {
    throw "There was an error analyzing $sourceFile`n$_"
  }
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'Predicate', 'Select', 'RuleViolation')
  Name    = 'GIVEN the public function Select-RuleViolation'
  Foreach = $data = @{
    SourceFile = $sourceFile
    DataDirectory = $dataDirectory
  }
}
Describe @options {

  Context 'WHEN The function is sourced in the current environment' {
    BeforeAll {
      $sourceFile = $_.SourceFile
      $dataDirectory = $_.DataDirectory
      if ($sourceFile | Test-Path) {
        $content = (Get-Content $sourceFile -Raw)
        $tokens      = $null
        $parseErrors = $null
        $results = [Parser]::ParseInput($content, [ref]$tokens, [ref]$parseErrors)
        $predicate = { param($Ast) $ast -is [FunctionDefinitionAst] }
        $functionAst = $results.Find($predicate, $false)
      }
    }

    It 'THEN it should parse without error' {
      $parseErrors | Should -BeNullOrEmpty
    }
    It 'THEN it should load without error' {
      (Get-Command 'Select-RuleViolation') | Should -Not -BeNullOrEmpty
    }

    It 'THEN it should contain a function' {
      $functionAst | Should -Not -BeNullOrEmpty
    }

    It 'THEN the function name should match the file name' {
      $functionAst.Name | Should -BeLike ($sourceFile | Split-Path -LeafBase)
    }
  }

  Context 'WHEN the <rule.RuleName> rule is tested' -ForEach $analyzerRules {
    BeforeAll {
      # Rename automatic variable to rule to make it easier to work with
      $rule = $_
    }

    It 'THEN it should pass' {
      $analysis | Should -Pass $rule
    }
  }
  <# --=-- #>
  Context 'WHEN given an AST and a predicate' -ForEach @(
    'CaseOfTrap'
  ){
    BeforeAll {
      $predicateFile = (Join-Path $dataDirectory "${_}-predicate.ps1")
      $scriptBlockFile = (Join-Path $dataDirectory "${_}-scriptblock.ps1")

      if ($predicateFile | Test-Path) {
        $predicate = [scriptblock]::Create((Get-Content $predicateFile -Raw))
      } else {
        throw "$predicateFile is not a valid path"
      }

      if ($scriptBlockFile | Test-Path) {
        $scriptBlock = Get-Item $scriptBlockFile | ConvertTo-Ast
      } else {
        throw "$scriptBlockFile is not a valid path"
      }

      $result = $scriptBlock | Select-RuleViolation $predicate
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
