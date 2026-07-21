using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'Test', 'CobolCase')
  Name    = 'given the private function Test-CobolCase'
  Foreach = $dataDirectory
}
Describe @options {
  BeforeAll {
    $dataDirectory = $_
  }
  <# --=-- #>
  Context "WHEN the phrase '<Phrase>' is tested" -ForEach (
    Get-ChildItem $dataDirectory -Filter *.psd1
    | ForEach-Object { Import-Psd $_ }
  ) {
    BeforeEach {
      $result = $Phrase | Test-CobolCase
    }

    It 'THEN it should be <Expect>' {
      $result | Should -Be $Expect
    }
  }
  <# --=-- #>
}
