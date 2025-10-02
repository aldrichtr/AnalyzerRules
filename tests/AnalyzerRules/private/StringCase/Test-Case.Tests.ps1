using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'Test', 'Case')
  Name    = 'given the private function Test-Case'
  Foreach = $dataDirectory
}
Describe @options {
  BeforeAll {
    $dataDirectory = $_
  }

  <# --=-- #>
  Context 'WHEN the phrase is <TestInput>' -ForEach (
    Get-ChildItem $dataDirectory -Filter *.psd1
  | ForEach-Object { Import-Psd $_ }
  ) {
    BeforeAll {
      $params = @{
        TestInput   = $TestInput
        TestOptions = $TestOptions
      }
      $result = $TestInput | Test-Case @TestOptions
    }

    It 'THEN the pattern should be <Expect>' {
      $result | Should -Be $Expect
    }
  }
  <# --=-- #>
}
