
<#
.SYNOPSIS
  Data-driven tests for Split-Phrase
#>

BeforeDiscovery {
  $dataPath = Join-Path $PSScriptRoot 'data'
  $script:testDef = Import-PowerShellDataFile (Join-Path $dataPath 'Split-Phrase.TestData.psd1')
}

Describe 'GIVEN the function Split-Phrase' -Tag @('unit', 'StringCase', 'Split-Phrase') {

  Context "WHEN the phrase '<Phrase>' is split" -ForEach $script:testDef.TestCases {

    BeforeAll {
      try {
        $result = $Phrase | Split-Phrase
      }
      catch {
        $_.ToString() | Add-Content "~/projects/AnalyzerRules/test-errors.log"
      }
    }

    It 'THEN it should produce <Expect.Count> words' {
      $result.Count | Should-Be $Expect.Count
    }

    It 'THEN it should produce the expected words' {
      $diff = Compare-Object $result $Expect
      $diff | Should-BeNull
    }
  }
}
