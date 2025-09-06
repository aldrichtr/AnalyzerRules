@{
  Run          = @{
    <# 'Directories to be searched for tests, paths directly to test files, or combination of both.' #>
    Path                   = @( '.')
    <# 'Directories or files to be excluded from the run.' #>
    ExcludePath            = @()
    <# 'ScriptBlocks containing tests to be executed.' #>
    ScriptBlock            = @()
    <# 'ContainerInfo objects containing tests to be executed.' #>
    Container              = @()
    <# 'Filter used to identify test files.' #>
    TestExtension          = '.Tests.ps1'
    <# 'Exit with non-zero exit code when the test run fails. Exit code is always set to `$LASTEXITCODE` even
        when this option is `$false`. When used together with Throw, throwing an exception is preferred.' #>
    Exit                   = $false
    <#
         # Throw an exception when test run fails. When used together with Exit, throwing an exception is
         # preferred.
         #>
    Throw                  = $false
    <# 'Return result object to the pipeline after finishing the test run.' #>
    PassThru               = $false
    <# 'Runs the discovery phase but skips run. Use it with PassThru to get object populated with all tests.' #>
    SkipRun                =  $false
    <# 'Skips remaining tests after failure for selected scope, options are None, Run, Container and Block.' #>
    SkipRemainingOnFailure =  'None'
  }
  Filter       = @{
    <# 'Tags of Describe, Context or It to be run.' #>
    Tag         =  @()
    <# 'Tags of Describe, Context or It to be excluded from the run.' #>
    ExcludeTag  =  @()
    <# 'Filter by file and scriptblock start line, useful to run parsed tests programmatically to avoid problems with expanded names. Example: ''C:\tests\file1.Tests.ps1:37''' #>
    Line        =  @()
    <# 'Exclude by file and scriptblock start line, takes precedence over Line.' #>
    ExcludeLine =  @()
    <# 'Full name of test with -like wildcards, joined by dot. Example: ''*.describe Get-Item.test1''' #>
    FullName    =  @()
  }
  CodeCoverage = @{
    <# 'Enable CodeCoverage.' #>
    Enabled               =  $false
    <# 'Format to use for code coverage report. Possible values: JaCoCo, CoverageGutters, Cobertura' #>
    OutputFormat          =  'JaCoCo'
    <# 'Path relative to the current directory where code coverage report is saved.' #>
    OutputPath            =  'coverage.xml'
    <# 'Encoding of the output file.' #>
    OutputEncoding        =  'UTF8'
    <# 'Directories or files to be used for code coverage, by default the Path(s) from general settings are used, unless overridden here.' #>
    Path                  =  @()
    <# 'Exclude tests from code coverage. This uses the TestFilter from general configuration.' #>
    ExcludeTests          =  $true
    <# 'Will recurse through directories in the Path option.' #>
    RecursePaths          =  $true
    <# 'Target percent of code coverage that you want to achieve, default 75%.' #>
    CoveragePercentTarget =  75
    <# 'EXPERIMENTAL: When false, use Profiler based tracer to do CodeCoverage instead of using breakpoints.' #>
    UseBreakpoints        =  $true
    <# 'Remove breakpoint when it is hit.' #>
    SingleHitBreakpoints  =  $true
  }
  TestResult   = @{
    <# 'Enable TestResult.' #>
    Enabled        =  $false
    <# 'Format to use for test result report. Possible values: NUnitXml, NUnit2.5, NUnit3 or JUnitXml' #>
    OutputFormat   =  'NUnitXml'
    <# 'Path relative to the current directory where test result report is saved.' #>
    OutputPath     =  'testResults.xml'
    <# 'Encoding of the output file.' #>
    OutputEncoding =  'UTF8'
    <# 'Set the name assigned to the root ''test-suite'' element.' #>
    TestSuiteName  =  'Pester'
  }
  Should       = @{
    <# 'Controls if Should throws on error. Use ''Stop'' to throw on error, or ''Continue'' to fail at the end of the test.' #>
    ErrorAction =  'Stop'
  }
  Debug        = @{
    <# 'Show full errors including Pester internal stack. This property is deprecated, and if set to true it will override Output.StackTraceVerbosity to ''Full''.' #>
    ShowFullErrors         =  $false
    <# 'Write Debug messages to screen.' #>
    WriteDebugMessages     =  $false
    <# 'Write Debug messages from a given source, WriteDebugMessages must be set to true for this to work. You can use like wildcards to get messages from multiple sources, as well as * to get everything.' #>
    WriteDebugMessagesFrom = @( 'Discovery', 'Skip', 'Mock', 'CodeCoverage')
    <# 'Write paths after every block and test, for easy navigation in VSCode.' #>
    ShowNavigationMarkers  =  $true
    <# 'Returns unfiltered result object, this is for development only. Do not rely on this object for additional properties, non-public properties will be renamed without previous notice.' #>
    ReturnRawResultObject  =  $false
  }
  Output       = @{
    <# 'The verbosity of output, options are None, Normal, Detailed and Diagnostic.' #>
    Verbosity           =  'Normal'
    <# 'The verbosity of stacktrace output, options are None, FirstLine, Filtered and Full.' #>
    StackTraceVerbosity =  'Filtered'
    <# 'The CI format of error output in build logs, options are None, Auto, AzureDevops and GithubActions.' #>
    CIFormat            =  'Auto'
    <# 'The CI log level in build logs, options are Error and Warning.' #>
    CILogLevel          =  'Error'
    <# 'The mode used to render console output, options are Auto, Ansi, ConsoleColor and Plaintext.' #>
    RenderMode          =  'Auto'
  }
  TestDrive    = @{
    <# 'Enable TestDrive.' #>
    Enabled =  $true
  }
  TestRegistry = @{
    <# 'Enable TestRegistry.' #>
    Enabled =  $true
  }
}
