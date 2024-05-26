param(
    # Output of Get-SourceItem
    [Parameter(
        ValueFromPipeline
    )]
    [PSTypeName('Stitch.SourceItemInfo')][Object[]]$Sources,

    # The path to the template to use
    [Parameter(
    )]
    [string]$Template,

    # Output to console instead of file
    [Parameter(
    )]
    [switch]$ToConsole
)

$magicComment = [regex]::Escape('<# --=-- #>')
$customContentMarker = "(?sm)^(\s*$magicComment.*$magicComment)"

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
        $testContent = Get-Content $newPath -Raw
        if (-not ([string]::IsNullorEmpty($testContent))) {
            $null = $testContent -match $customContentMarker
            if ($Matches.1) {
                "$($PSStyle.Foreground.Cyan)Test has custom content`n---$($PSStyle.Reset)"
                $customContent = $Matches.1
            } else {
                $customContent = ''
            }
            "$($PSStyle.Foreground.BrightBlack)$customContent$($PSStyle.Reset)"
        }
    }
    $testDir = $newPath | Split-Path

    #! Create the directories if they do not yet exist
    if (-not ($testDir | Test-Path)) {
        "- Creating directory $($PSStyle.Foreground.Cyan)$testDir$($PSStyle.Reset)"
        New-Item $testDir -ItemType Directory -Force
    }

    "Create Test $($PSStyle.Foreground.Blue)$($source.Name)$($PSStyle.Reset)"
    $newContent = (Invoke-StringTemplate -Definition $template -Parameters $source)

    if (-not ([string]::IsNullorEmpty($customContent))) {
        #! ok, this one is weird... if you have a $_ in the custom content, it gets
        #! replaced with the full text.  So first we "disrupt" the $_ to get the content
        #! into the output, then put the _ back
    $finalContent = (
        $newContent -replace $customContentMarker,
        ($customContent -replace '\$_', "`$@@underbar@@"))
    $finalContent = $finalContent -replace '@@underbar@@', '_'
    } else {
        $finalContent = $newContent
    }

    if ($ToConsole) {
        $finalContent
    } else {
        $finalContent | Set-Content $newPath
    }

}
