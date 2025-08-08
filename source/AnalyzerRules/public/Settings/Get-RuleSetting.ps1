
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer
function Get-RuleSetting {
    <#
    .SYNOPSIS
        Get the settings for the given rule
    #>
    [CmdletBinding(
        DefaultParameterSetName = 'one'
    )]
    param(
        # The name of the function used in the Settings File
        # If not given, then the caller's name will be used
        [Parameter(
            ParameterSetName = 'one',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$Setting,

        # Get the complete Settings table
        [Parameter(
        )]
        [switch]$All

    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        if ($All) {
            [Helper]::Instance.GetRuleArguments()

        } else {
            if ($PSBoundParameters.ContainsKey('Setting')) {
                <#------------------------------------------------------------------
             Our function names are in `Verb-Noun` format, but our Settings
             are going to be in the form of `VerbNoun`.  So, just in case the
             function name was passed in, format it before we do the lookup
            ------------------------------------------------------------------#>
                if ($Setting -match '(\w+)-(\w+)<\w+>') {
                    $Setting = Format-RuleName $Setting
                    | Select-Object -ExpandProperty ShortName
                } else {
                    $Setting = Get-PSCallStack
                    | Select-Object -First 1 -Skip 1
                    | Format-RuleName
                    | Select-Object -ExpandProperty ShortName
                }
                #! If the Setting is not found, this will return $null
                [Helper]::Instance.GetRuleArguments( $Setting )
            }
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
