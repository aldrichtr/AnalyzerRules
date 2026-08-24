
<#
.SYNOPSIS
  Data-driven tests for ConvertTo-*Case functions (ConvertTo-CamelCase, ConvertTo-SnakeCase, etc.)
.DESCRIPTION
  Loads all ConvertTo-*.TestData.psd1 files from the data directory and runs each function's
  test cases through the corresponding ConvertTo-*Case function.
#>

BeforeDiscovery {
  $dataPath = Join-Path $PSScriptRoot 'data'
  $script:testDataFiles = Get-ChildItem $dataPath -Filter 'ConvertTo-*.TestData.psd1' |
    ForEach-Object { Import-PowerShellDataFile $_.FullName }
}

Describe 'GIVEN the function <FunctionName>' -Tag @('unit', 'StringCase') `
  -ForEach $script:testDataFiles {

  Context "WHEN converting '<Phrase>'" -ForEach $TestCases {

    BeforeAll {
      $result = $Phrase | & $FunctionName
    }

    It 'THEN it should produce <Expect>' {
      $result | Should-Be $Expect
    }
  }
}
