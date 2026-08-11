using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'ConvertTo', 'CamelCase')
  Name    = 'given the private function ConvertTo-CamelCase'
 ForEach = $dataDirectory
}
Describe @options {
  BeforeAll {
    $dataDirectory = $_
  }
  <# --=-- #>
  Context 'WHEN converting the phrase <Phrase> to camel case' -ForEach (
    Get-ChildItem $dataDirectory -Filter *.psd1
    | ForEach-Object { Import-Psd $_ }
  ) {

    BeforeAll {
      $results = $Phrase | ConvertTo-CamelCase
    }
    It 'THEN it is formatted as <Expect>' {
      $results | Should -BeLike $Expect
    }
  }
  <# --=-- #>
}
