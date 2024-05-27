@{
    PSScriptAnalyzer = @{
        Version = 'latest'
        Tags = @('ci')
    }
    InvokeBuild = 'latest'
    Pester = @{
        Version = 'latest'
        Tags = @('ci')
    }
    PsdKit = @{
        Version = 'latest'
        Tags = @('ci')
    }


    # -- Dev kit
    stitch = @{
        Version = '0.5.0-beta6'
        Parameters = @{
            AllowPrerelease = $true
        }
        Tags = @('ci')
    }
}
