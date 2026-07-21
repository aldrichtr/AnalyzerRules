using namespace System.Management.Automation.Language

BeforeDiscovery {
  if (Get-Module 'TestHelpers') {
    $sourceFile = Get-SourceFilePath $PSCommandPath
  } else {
    throw 'TestHelpers module is not loaded'
  }
  if (-not (Test-Path $sourceFile)) {
    throw "Could not find $sourceFile from $PSCommandPath"
  }
  $analyzerRules = Get-ScriptAnalyzerRule -Severity Error, Warning
  | Where-Object {
    $_.RuleName -notmatch '(^PSDSC)|Manifest'
  }
  try {
    $analysis = Invoke-ScriptAnalyzer -Path $sourceFile -IncludeRule $analyzerRules
  } catch {
    throw "There was an error analyzing $sourceFile`n$_"
  }
  $dataDirectory = Get-TestDataPath
}

$options = @{
  Tag     = @( 'unit', 'StringCase', 'ConvertTo', 'SnakeCase')
  Name    = 'given the private function ConvertTo-SnakeCase'
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
      $result = $Phrase | ConvertTo-SnakeCase
    }

    It 'THEN it should be <Expect>' {
      $result | Should -Be $Expect
    }
  }
  <# --=-- #>
}
