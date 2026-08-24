
<#
.SYNOPSIS
  Data-driven tests for per-case Test-*Case functions (Test-CamelCase, Test-PascalCase, etc.)
.DESCRIPTION
  Loads all Test-*.TestData.psd1 files from the data directory and runs each function's
  test cases through the corresponding Test-*Case function.
#>

BeforeDiscovery {
  $dataPath = Join-Path $PSScriptRoot 'data'
  $script:testDataFiles = Get-ChildItem $dataPath -Filter 'Test-*Case.TestData.psd1' |
    Where-Object Name -ne 'Test-Case.TestData.psd1' |
    ForEach-Object { Import-PowerShellDataFile $_.FullName }
}

Describe 'GIVEN the function <FunctionName>' -Tag @('unit', 'StringCase') `
  -ForEach $script:testDataFiles {

  It "WHEN '<Phrase>' is tested THEN it should be <Expect>" -ForEach $TestCases {
    $result = $Phrase | & $FunctionName
    $result | Should-Be $Expect
  }
}
