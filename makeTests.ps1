param(
    # Output of Get-SourceItem
    [Parameter(
    )]
    [PSTypeName('Stitch.SourceItemInfo')][Object[]]$Sources,

    # The path to the template to use
    [Parameter(
    )]
    [string]$Template
)

$magicComment = [regex]::Escape('<# --=-- #>')
$customContentMarker = "^(\s*$magicComment.*$magicComment$)"

if (-not ($PSBoundParameters.ContainsKey('Sources'))) {
    $Sources = Get-SourceItem | Where-Object Type -Like function
}

if (-not ($PSBoundParameters.ContainsKey('Template'))) {
    $Template = (Get-Content "$env:HOME\.dotfiles\templates\pwsh\pester\unitTest\unitTest.st" -Raw)

}

foreach ($source in $Sources) {
    $newPath = ($source.Path | Resolve-Path -Relative) -replace 'source', 'tests'
    $newPath = $newPath -replace '\.ps1', '.Tests.ps1'

    if ($newPath | Test-Path) {
        $testContent = Get-Content $testContent -Raw
        if (-not ([string]::IsNullorEmpty($testContent))) {
            $null = $testContent -match $customContentMarker
            if ($Matches.1) {
                $customContent = $Matches.1
            } else {
                $customContent = ''
            }

        }
    }
    $testDir = $newPath | Split-Path

    #! Create the directories if they do not yet exist
    if (-not ($testDir | Test-Path)) {
        "- Creating directory $($PSStyle.Foreground.Cyan)$testDir$($PSStyle.Reset)"
        New-Item $testDir -ItemType Directory -Force
    }

    "Create Test $($PSStyle.Foreground.Blue)$($source.Name)$($PSStyle.Reset)"
    $newContent = Invoke-StringTemplate -Definition $template -Parameters $source

    $newContent = $newContent -replace $customContentMarker, $customContent

    if ($ToConsole) {
        $newContent
    } else {
        $newContent | Set-Content $newPath
    }

}
