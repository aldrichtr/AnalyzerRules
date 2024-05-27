@{
    #---------------------------------------------------------------------------
    #region Module Info

    ModuleVersion = '0.1.0'
    Description   = 'PSScriptAnalyzer Rules to analyze PowerShell module manifests'
    GUID = 'e7dcfedf-7828-428b-81ee-caec56e3abfc'
    # HelpInfoURI = ''

    #endregion Module Info
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Module Components

    RootModule = 'HelpSystem.psm1'
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

        } # end PSData
    } # end PrivateData
} # end hashtable
