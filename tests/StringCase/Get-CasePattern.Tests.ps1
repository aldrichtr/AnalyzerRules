
<#
.SYNOPSIS
  Data-driven tests for Get-CasePattern
#>

BeforeDiscovery {
  $dataPath = Join-Path $PSScriptRoot 'data'
  $script:testDef = Import-PowerShellDataFile (Join-Path $dataPath 'Get-CasePattern.TestData.psd1')
}

Describe 'GIVEN the function Get-CasePattern' -Tag @('unit', 'StringCase', 'Get-CasePattern') {

  Context 'WHEN WordCase is <WordCase> and DontAllowDigits is <DontAllowDigits>' -ForEach $script:testDef.TestCases {

    BeforeAll {
      $result = Get-CasePattern $WordCase -DontAllowDigits:$DontAllowDigits
    }

    It 'THEN the pattern should be <Expect>' {
      $result | Should-Be $Expect
    }
  }
}
