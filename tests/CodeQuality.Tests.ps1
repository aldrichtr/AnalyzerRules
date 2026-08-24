
using namespace System.Management.Automation.Language

<#
.SYNOPSIS
  Code quality gate - runs PSScriptAnalyzer against all source function files.
.DESCRIPTION
  Discovers all .ps1 files under source/*/public and source/*/private, parses each
  one and runs PSScriptAnalyzer rules against them. Failures are surfaced as test
  failures with file, line, and rule information.

  Tags: 'cq', 'code-quality'
  Use -ExcludeTag 'cq' to skip these during unit testing.
#>

BeforeDiscovery {
  $testsDirectory = $PSCommandPath | Split-Path | Get-Item
  if ($testsDirectory.Name -notlike 'tests') { throw 'CodeQuality Tests file is not in the tests directory' }

  $sourceDirectory = $testsDirectory -replace 'tests$', 'source'

  $fDirOptions = @{
    Path      = $sourceDirectory
    Recurse   = $true
    Directory = $true
    Include   = @('public', 'private')
  }
  $functionDirectories = Get-ChildItem @fDirOptions

  $script:functionFiles = @()
  foreach ($dir in $functionDirectories) {
    $fFileOptions = @{
      Path    = $dir
      Recurse = $true
      File    = $true
      Filter  = '*.ps1'
    }
    $script:functionFiles += @(Get-ChildItem @fFileOptions)
  }
}

Describe 'SCENARIO The file <_.Name> is inspected for code quality' `
  -Tag @('cq', 'code-quality') `
  -ForEach $script:functionFiles {

  BeforeAll {
    $sourceFile = $_
    $content = Get-Content $sourceFile -Raw

    $tokens = $null
    $parseErrors = $null
    $scriptAst = [Parser]::ParseInput($content, [ref]$tokens, [ref]$parseErrors)

    $predicate = { param($Ast) $Ast -is [FunctionDefinitionAst] }
    $functionAst = $scriptAst.Find($predicate, $false)
  }

  Context 'GIVEN the file is parsed' -Tag @('parse') {

    It 'THEN it should parse without error' {
      $parseErrors | Should-BeNull
    }

    It 'THEN parsing should produce a FunctionDefinitionAst' {
      $functionAst | Should-NotBeNull
      $functionAst | Should-HaveType ([FunctionDefinitionAst])
    }

    It 'THEN the file name (<_.BaseName>) should match the function name' {
      $baseName = ($sourceFile | Split-Path -LeafBase)
      $functionAst.Name | Should-BeLikeString $baseName
    }

    It 'THEN the function should be loadable in the current session' {
      Get-Command $functionAst.Name -ErrorAction SilentlyContinue | Should-NotBeNull
    }
  }

  Context 'GIVEN the file is analyzed by PSScriptAnalyzer' -Tag @('analyze') {

    BeforeAll {
      $analysisOptions = @{
        Path     = $sourceFile.FullName
        Severity = @('Error', 'Warning')
      }
      $violations = @(Invoke-ScriptAnalyzer @analysisOptions)
    }

    It 'THEN it should have no errors or warnings' {
      if ($violations.Length -gt 0) {
        $messages = $violations | ForEach-Object {
          '  [{0}] {1} - L{2}:C{3} - {4}' -f @(
            $_.Severity,
            $_.RuleName,
            (${_}?.Extent?.StartLineNumber ?? '?'),
            (${_}?.Extent?.StartColumnNumber ?? '?'),
            $_.Message
          )
        }
        $detail = @(
          "Found $($violations.Length) violation(s):",
          ($messages -join "`n")
        ) -join "`n"

        $null | Should-NotBeNull -Because $detail
      }
    }
  }
}
