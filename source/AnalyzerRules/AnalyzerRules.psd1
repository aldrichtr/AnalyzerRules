@{
    #---------------------------------------------------------------------------
    #region Module Info

    ModuleVersion = '0.1.0'
    Description = 'Custom rules for PSScriptAnalyzer'
    GUID = 'ab3b906a-640f-48e2-b78e-cd98d64a907a'
    # HelpInfoURI = ''

    #endregion Module Info
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Module Components

    RootModule = 'AnalyzerRules.psm1'
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    # ModuleList = ''
    # FileList = @()

    #endregion Module Components
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Public Interface

    CmdletsToExport = '*'
    FunctionsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = '*'
    # DSCResourcesToExport = @()
    # DefaultCommandPrefix = ''

    #endregion Public Interface
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Requirements

    # CompatiblePSEditions = @()
    # PowerShellVersion = ''
    # PowershellHostName = ''
    # PowershellHestVersion = ''
    # RequiredModules = ''
    # RequiredAssemblies = ''
    # ProcessorArchitecture = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''

    #endregion Requirements
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Author

    Author = 'Timothy Aldrich'
    CompanyName = 'aldrichtr'
    Copyright = '(c) Timothy Aldrich. All rights reserved.'

    #endregion Author
    #---------------------------------------------------------------------------

    PrivateData = @{
        PSData = @{
        #---------------------------------------------------------------------------
        #region Project

        Tags = @()
        LicenseUri = ''
        ProjectUri = ''
        IconUri = ''
        PreRelease = ''
        RequireLicenseAcceptance = ''
        ExternalModuleDependencies = @()
        ReleaseNotes = ''

        #endregion Project
        #---------------------------------------------------------------------------
        }  # end PSData
    } # end PrivateData
} # end hashtable
