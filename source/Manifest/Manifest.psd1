@{
    #---------------------------------------------------------------------------
    #region Module Info

    ModuleVersion = '0.1.0'
    Description = 'Rules for analyzing PowerShell module manifests'
    GUID = '26c2195e-b946-4256-9996-5248c95c3011'
    # HelpInfoURI = ''

    #endregion Module Info
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Module Components

    RootModule = 'Manifest.psm1'
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

    Author = 'aldrichtr'
    CompanyName = 'aldrichtr'
    Copyright = '(c) aldrichtr. All rights reserved.'

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
