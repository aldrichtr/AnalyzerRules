param(
  # Build Markdown Documents
  [Parameter(
  )]
  [switch]$WithDocs
)
$stitchDir = (Join-Path $env:XDG_CONFIG_HOME 'stitch')
$toolsDir = (Join-Path $stitchDir 'tools')

task Clean {
  @('stage')
  | ForEach-Object {
    Get-ChildItem "$BuildRoot/$_"
    | Remove-Item -Recurse -Force
  }

}

task Validate -Before Compile {
  @('docs', 'out', 'publish', 'stage')
  | ForEach-Object {
    $dir = (Join-Path $BuildRoot $_)
    if (-not ($dir | Test-Path)) {
      New-Item -Path $dir -ItemType Directory
    }
  }
}

task Compile -Before Build {
  $projectFiles = Get-ChildItem $BuildRoot -Filter '*.csproj' -Recurse
  $solutionFiles = Get-ChildItem $BuildRoot -Filter '*.sln' -Recurse
  if (($null -ne $projectFiles) -or ($null -ne $solutionFiles)) {
    & dotnet @('build')
  }
}

task Build -Before Test {
  Get-ChildItem source -Directory
  | ForEach-Object {
    Set-Location $_
    Build-Module -OutputDirectory '..\..\stage'
  }
  Set-Location $BuildRoot
}

task Test -Before Install {
  . "$toolsDir\runTests.ps1"
}

task Install {}

task Uninstall {}

task Publish {}

task . Build

task CreateDocs -After Build -If ($WithDocs) {
  $outputDir = "$BuildRoot\docs"
  if (-not ($outputDir | Test-Path)) {
    New-Item $outputDir -ItemType Directory -Force
  }
  Import-Module Microsoft.PowerShell.PlatyPS
  . "$toolsDir\loadStagedModules.ps1"
  $options = @{
    ModuleInfo     = (Get-Module 'PSOrgMode')
    OutputFolder   = $outputDir
    WithModulePage = $true
  }
  New-MarkdownCommandHelp @options
}



task bumpVersion {
  $versionInfo = Get-GitVersion
  Update-Metadata -Path 'source/PSOrgMode/PSOrgMode.psd1' -PropertyName ModuleVersion -Value $versionInfo.MajorMinorPatch
  Update-Metadata -Path 'source/PSOrgMode/PSOrgMode.psd1' -PropertyName PreRelease -Value $versionInfo.InformationalVersion
}
