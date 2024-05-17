
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
        [Parameter(
            ParameterSetName = 'one',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$Setting,

        # Return all settings
        [Parameter(
            ParameterSetName = 'all'
        )]
        [switch]$All
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        $allSettings = [Helper]::Instance.GetRuleArguments()
        if ($null -$allSettings) {
            if ($All) {
                $allSettings
            } else {
                if ($PSBoundParameters.ContainsKey('Setting')) {
                    if ($Setting -match '(\w+)-(\w+)<\w+>') {
                        $Setting = Format-RuleName $Setting
                        | Select-Object -ExpandProperty ShortName
                    }
                } else {
                    $Setting = Get-PSCallStack
                    | Select-Object -First 1 -Skip 1
                    | Format-RuleName
                    | Select-Object -ExpandProperty ShortName
                }

                if ($allSettings.ContainsKey($Setting)) {
                    $allSettings[$Setting]
                } else {
                    Write-Verbose "No settings for $Setting were found"
                }
            }
        } else {
            Write-Verbose 'Could not retrieve rule settings'
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
