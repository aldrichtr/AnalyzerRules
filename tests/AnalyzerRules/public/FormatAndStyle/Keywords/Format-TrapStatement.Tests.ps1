
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
  $analysis = Invoke-ScriptAnalyzer -Path $sourceFile -IncludeRule $analyzerRules

  $dataDirectory = (Get-TestDataPath $PSCommandPath)

}


$options = @{
  Name    = 'GIVEN the public function Format-TrapStatement'
  Tag     = @(
    'unit',
    'Format',
    'TrapStatement'
  )
  Foreach = $sourceFile
}
Describe @options {
  BeforeAll {
    $sourceFile = $_
  }
  Context 'WHEN The function is sourced in the current environment' -Tag @('fileParse') {
    BeforeAll {
      $tokens      = $null
      $parseErrors = $null
      $result = [Parser]::ParseFile($sourceFile, [ref ]$tokens, [ref ]$parseErrors)
    }

    It 'THEN it should parse without error' {
      $parseErrors | Should -BeNullOrEmpty
    }
    It 'THEN it should load without error' {
      (Get-Command 'Format-TrapStatement') | Should -Not -BeNullOrEmpty
    }
  }

  Context 'WHEN the <rule.RuleName> rule is tested' -Tag @('fileAnalysis') -ForEach $analyzerRules {
    BeforeAll {
      # Rename automatic variable to rule to make it easier to work with
      $rule = $_
    }

    It 'THEN it should pass' {
      $analysis | Should -Pass $rule
    }
  }

  <# --=-- #>
  Context 'GIVEN that we pass a scriptblock to Format-TrapStatement outside ScriptAnalyzer' -Tag @("Raw") -ForEach @(
    @{
      ScriptBlock = @'
{ TRAP { Write-Warning "Yikes, a trap!"}}
'@
      ResultCount = 1
    }
  ) {
    BeforeAll {
      Mock Get-RuleSetting -ModuleName AnalyzerRules -MockWith {
        return @{
          Enabled = $true
          Case    = 'lower'
        }
      }

      $scriptAst = ConvertTo-Ast $ScriptBlock
      $trapAst = $scriptAst.Find({ param($ast) $ast -is [TrapStatementAst] }, $true)
      $result = Format-TrapStatement -TrapStatementAst $trapAst
    }
    It 'It should have <ResultCount> Results' {
      $result.Count | Should -Be $ResultCount
    }
  }

  Context 'When ScriptAnalyzer is called with <AnalyzerOptions.IncludeRule>' -ForEach @(
    @{
      AnalyzerOptions = @{
        ScriptDefinition      = @'
function Test-CaseOfTrap {
[CmdletBinding()]
param()
begin {}
process { Trap { Write-Warning "Yikes, a trap!"}}
}
'@
        CustomRulePath        = 'stage'
        RecurseCustomRulePath = $true
        IncludeDefaultRules   = $false
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
      ResultCount     = 1
    },
    @{
      AnalyzerOptions = @{
        ScriptDefinition      = @'
function Test-CaseOfTrap1 {
[CmdletBinding()]
param()
begin {}
process { TRAP { Write-Warning "Yikes, a trap!"}}
}
'@
        CustomRulePath        = 'stage'
        RecurseCustomRulePath = $true
        IncludeDefaultRules   = $false
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
      ResultCount     = 1
    }
  ) {
    BeforeEach {
      $result = Invoke-ScriptAnalyzer @AnalyzerOptions
    }

    It 'It should have a result count of <ResultCount>' {
      $result.Count | Should -Be $ResultCount
    }

  }

  <# --=-- #>
}
