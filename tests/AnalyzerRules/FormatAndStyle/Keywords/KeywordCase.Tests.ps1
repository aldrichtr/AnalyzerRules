
using namespace System.Management.Automation.Language

<#
.SYNOPSIS
  Data-driven test runner for all Format-* keyword case rules.
.DESCRIPTION
  Reads PSD1 test data files from the ./data/ directory. Each file defines:
    - FunctionName : the public function to test
    - AstType      : the AST class name to find in the parsed script
    - Categories   : the RuleCategory attributes on the function
    - TestCases    : array of test case hashtables

  Each test case provides:
    - Name       : test description (used in -ForEach expansion)
    - Settings   : hashtable to return from mocked Get-RuleSetting
    - Script     : PowerShell code to parse and analyze
    - Expected   : 'pass' (no violation) or 'fail' (violation expected)
    - Correction : (optional) expected corrected keyword text when Expected='fail'
#>

$dataPath = Join-Path $PSScriptRoot 'data'
$testDataFiles = Get-ChildItem $dataPath -Filter '*.TestData.psd1'

Describe 'Format Keyword Case Rules' -Tag @('unit', 'FormatAndStyle', 'Keywords') `
  -ForEach @($testDataFiles | ForEach-Object {
    $def = Import-PowerShellDataFile $_.FullName
    @{
      DataFile     = $_.Name
      FunctionName = $def.FunctionName
      AstType      = $def.AstType
      Categories   = $def.Categories
      TestCases    = $def.TestCases
    }
  }) {

  Context 'GIVEN the function <FunctionName>' -Tag @($FunctionName) {

    BeforeAll {
      Mock Get-RuleSetting -ModuleName AnalyzerRules -MockWith {
        param($KeyName)
        if ($null -eq $script:currentTestSettings -or $script:currentTestSettings.Count -eq 0) {
          return $null
        }
        if ([string]::IsNullOrEmpty($KeyName)) {
          return $null
        }
        if ($script:currentTestSettings.ContainsKey($KeyName)) {
          return $script:currentTestSettings[$KeyName]
        }
        return $null
      }
    }

    Context 'WHEN <Name>' -Tag @('case') -ForEach $TestCases {

      BeforeEach {
        # Store the current test case's settings at script scope so the mock can access them
        $script:currentTestSettings = $Settings

        # The Input AST Type
        $astTypeRef = [Type]"System.Management.Automation.Language.$AstType"

        $errors = @()
        $tokens = @()

        # The result of parsing the `Script` string.  This will result in a `ScriptBlockAst`
        # but we want the "inner" AST
        $scriptAst = [Parser]::ParseInput($Script, [ref]$tokens, [ref]$errors)

        # The AST we want to test
        $targetAst = $scriptAst.FindAll(
          { param($a) $a -is $astTypeRef },
          $true
        ) | Select-Object -First 1

        [array]$result = (& $FunctionName -InputAst $targetAst)
      }

      It "THEN '<Script>' should parse without error" {
        $errors.Count | Should-Be 0
      }

      It 'THEN the <AstType> Should be Found' {
        $targetAst | Should-NotBeNull

      }

      It 'THEN the AST type should be <AstType>' {
        $targetAst | Should-HaveType ($astTypeRef)
      }


      It 'THEN it should <Expected>' {

        if ($Expected -eq 'pass') {
          $result | Should-BeNull -Because 'no violation expected'
        } else {
          $result | Should-NotBeNull -Because 'a violation is expected'

          if ($Correction) {
            # Verify the suggested correction contains the expected keyword
            $correctionText = $result[0].SuggestedCorrections[0].Text
            $correctionText | Should-BeLikeString "*$Correction*" `

          }
        }
      }
    }
  }
}
