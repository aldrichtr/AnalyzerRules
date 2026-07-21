using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'ConvertTo', 'DotCase')
  Name    = 'given the private function ConvertTo-DotCase'
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
      $result = $Phrase | ConvertTo-DotCase
    }

    It 'THEN it should be <Expect>' {
      $result | Should -Be $Expect
    }
  }
  <# --=-- #>
}
