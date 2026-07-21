using namespace System.Management.Automation.Language

BeforeDiscovery {
  $dataDirectory = Get-TestDataPath
}
$options = @{
  Tag     = @( 'unit', 'FormatAndStyle', 'Operators', 'Format', 'TypeOperator')
  Name    = 'GIVEN the public function Format-TypeOperator'
  Foreach = $dataDirectory
}

Describe @options {
  BeforeAll {
    $dataDirectory = $_
  }
  <# --=-- #>
  <# --=-- #>
}
