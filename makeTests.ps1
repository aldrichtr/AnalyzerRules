$sources = Get-SourceItem | Where-Object Type -Like function
$template = (Get-Content "$env:HOME\.dotfiles\templates\unit-test.st" -Raw)

foreach ($source in $sources) {
    $newPath = ($source.Path | Resolve-Path -Relative) -replace 'source', 'tests'
    $newPath = $newPath -replace '\.ps1', '.Tests.ps1'

    $testDir = $newPath | Split-Path
    if (-not ($testDir | Test-Path)) {
        "- Creating directory $($PSStyle.Foreground.Cyan)$testDir$($PSStyle.Reset)"
        New-Item $testDir -ItemType Directory -Force
    }


    $params = @{
        noun = $source.Noun
        verb = $source.Verb
        component = $source.Component
    }

    "Create Test $($PSStyle.Foreground.Blue)$($source.Name)$($PSStyle.Reset)"
    Invoke-StringTemplate -Definition $template -Parameters $params | Set-Content $newPath
}
