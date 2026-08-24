@{
  Severity              = @( 'Information', 'Warning', 'Error')
  IncludeDefaultRules   = $true

  CustomRulePath        = @()
  RecurseCustomRulePath = $false

  IncludeRules          = @('*')
  ExcludeRules          = @( 'PSDSC*')

  #-------------------------------------------------------------------------------

  Rules                 = @{
    PSAvoidUsingCmdletAliases  = @{
      allowlist = @(
        'task'
      )
    }

    PSUseConsistentIndentation = @{
      Enable              = $true
      Kind                = 'space'
      PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
      IndentationSize     = 2
    }

    PSUseCorrectCasing         = @{
      Enable = $true
    }

    PSUseConsistentWhitespace  = @{
      Enable                                  = $true
      CheckOpenParen                          = $true
      CheckPipeForRedundantWhitespace         = $false
      CheckInnerBrace                         = $true
      CheckOperator                           = $true
      CheckOpenBrace                          = $true
      IgnoreAssignmentOperatorInsideHashTable = $true
      CheckPipe                               = $true
      CheckParameter                          = $false
      CheckSeparator                          = $true
    }

    PSAlignAssignmentStatement = @{
      Enable         = $true
      CheckHashtable = $true
    }

    PSPlaceOpenBrace           = @{
      Enable             = $true
      NewLineAfter       = $true
      OnSameLine         = $true
      IgnoreOneLineBlock = $true
    }

    PSPlaceCloseBrace          = @{
      Enable             = $true
      NewLineAfter       = $false
      NoEmptyLineBefore  = $true
      IgnoreOneLineBlock = $true
    }
  }
}
