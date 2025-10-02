using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'Get', 'CasePattern')
  Name    = 'GIVEN the private function Get-CasePattern'
  Foreach = $dataDirectory
}
Describe @options {
  BeforeAll {
    $dataDirectory = $_
  }
  <# --=-- #>

  Context 'WHEN the word case is <WordCase> and DontAllowDigits is <DontAllowDigits>' -ForEach (
    Get-ChildItem $dataDirectory -Filter *.psd1
    | ForEach-Object { Import-Psd $_ }
  ) {
    BeforeEach {
      $result = Get-CasePattern $WordCase -DontAllowDigits:$DontAllowDigits
    }

    It 'THEN the pattern should be <Expect>' {
      $result | Should -BeExactly $Expect
    }
  }
  <# --=-- #>
}
