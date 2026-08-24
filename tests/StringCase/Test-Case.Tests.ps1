
<#
.SYNOPSIS
  Data-driven tests for Test-Case (the general-purpose case tester)
#>

BeforeDiscovery {
  $dataPath = Join-Path $PSScriptRoot 'data'
  $script:testDef = Import-PowerShellDataFile (Join-Path $dataPath 'Test-Case.TestData.psd1')
}

Describe 'GIVEN the function Test-Case' -Tag @('unit', 'StringCase', 'Test-Case') {

  Context "WHEN '<TestInput>' is tested with options <TestOptions>" -ForEach $script:testDef.TestCases {

    BeforeAll {
      $result = $TestInput | Test-Case @TestOptions
    }

    It 'THEN the result should be <Expect>' {
      $result | Should-Be $Expect
    }
  }
}
