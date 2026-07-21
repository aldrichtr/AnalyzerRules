using namespace System.Management.Automation.Language

BeforeDiscovery {
  dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'Split', 'Phrase')
  Name    = 'given the private function Split-Phrase'
  Foreach = $dataDirectory
}
Describe @options {
  BeforeAll {
    $dataDirectory = $_
  }
  <# --=-- #>

  Context "WHEN the phrase '<Phrase>' is given" -ForEach (
    Get-ChildItem $dataDirectory -Filter *.psd1
    | ForEach-Object { Import-Psd $_ }
  ) {
    BeforeEach {
      $result = $Phrase | Split-Phrase
    }

    It 'THEN it should be split into <Expect.Count> words' {
      $result.Count | Should -BeExactly $Expect.Count
    }

    It "THEN '<Phrase>' is split into <Expect>" {
      (Compare-Object $result $Expect).InputObject | Should -BeNullOrEmpty
    }
  }
  <# --=-- #>
}
