using namespace System.Management.Automation.Language

BeforeDiscovery {
  if (Get-Module 'TestHelpers') {
    $sourceFile = Get-SourceFilePath $PSCommandPath
  } else {
    throw 'TestHelpers module is not loaded'
  }
  if (-not (Test-Path $sourceFile)) {
    throw "Could not find $sourceFile from $PSCommandPath"
  }
  $analyzerRules = Get-ScriptAnalyzerRule -Severity Error, Warning
  | Where-Object {
    $_.RuleName -notmatch '(^PSDSC)|Manifest'
  }
  $analysis = Invoke-ScriptAnalyzer -Path $sourceFile -IncludeRule $analyzerRules
}


$options = @{
  Name    = 'GIVEN the public function Format-TrapStatement'
  Tag     = @(
    'unit',
    'Format-TrapStatement'
  )
  Foreach = $sourceFile
}
Describe @options {
  BeforeAll {
    $sourceFile = $_
    Write-Debug "Testing Source file $sourceFile"
  }
  Context 'WHEN The function is sourced in the current environment' {
    BeforeAll {
      $tokens      = $null
      $parseErrors = $null
      [Parser ]::ParseFile($sourceFile, [ref ]$tokens, [ref ]$parseErrors)
    }

    It 'THEN it should parse without error' {
      $parseErrors | Should -BeNullOrEmpty
    }
    It 'THEN it should load without error' {
      (Get-Command 'Format-TrapStatement') | Should -Not -BeNullOrEmpty
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

  Context 'When ScriptAnalyzer is called with <AnalyzerOptions.IncludeRule>' -ForEach @(
    @{
      AnalyzerOptions = @{
        ScriptDefinition      = "{ trap { Write-Host 'Hello World' } }"
        CustomRulePath        = 'stage'
        RecurseCustomRulePath = $true
        IncludeDefaultRules    = $false
        IncludeRule           = 'Format-TrapStatement'
        Settings              = @{
          Rules = @{
            FormatTrapStatement = @{
              Enabled = $true
              Case    = 'lower'
            }
          }
        }
      }
      ResultCount     = 0
    }
  ) {
    BeforeAll {
      $result = Invoke-ScriptAnalyzer @AnalyzerOptions
    }
    It 'It should have a result count of <ResultCount>' {
      $result.Count | Should -Be $ResultCount
    }

  }
}
