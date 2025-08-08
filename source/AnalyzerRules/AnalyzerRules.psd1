@{
    #---------------------------------------------------------------------------
    # SECTION Module Info

    ModuleVersion = '0.1.0'
    Description = 'Custom rules for PSScriptAnalyzer'
    GUID = 'ab3b906a-640f-48e2-b78e-cd98d64a907a'
    # HelpInfoURI = ''

    # !SECTION Module Info
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    # SECTION Module Components

    RootModule = 'AnalyzerRules.psm1'
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    # ModuleList = ''
    # FileList = @()

    # !SECTION Module Components
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    # SECTION Public Interface

    CmdletsToExport = '*'
    FunctionsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = '*'
    # DSCResourcesToExport = @()
    # DefaultCommandPrefix = ''

    # !SECTION Public Interface
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    # SECTION Requirements

    # CompatiblePSEditions = @()
    # PowerShellVersion = ''
    # PowershellHostName = ''
    # PowershellHestVersion = ''
    # RequiredModules = ''
    # RequiredAssemblies = ''
    # ProcessorArchitecture = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''

    # !SECTION Requirements
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    # SECTION Author

    Author = 'Timothy Aldrich'
    CompanyName = 'aldrichtr'
    Copyright = '(c) Timothy Aldrich. All rights reserved.'

    # !SECTION Author
    #---------------------------------------------------------------------------

    PrivateData = @{
        PSData = @{
        #---------------------------------------------------------------------------
        # SECTION Project

        Tags = @()
        LicenseUri = ''
        ProjectUri = ''
        IconUri = ''
        PreRelease = ''
        RequireLicenseAcceptance = ''
        ExternalModuleDependencies = @()
        ReleaseNotes = ''

        # !SECTION Project
        #---------------------------------------------------------------------------
        }  # end PSData
    } # end PrivateData
} # end hashtable
