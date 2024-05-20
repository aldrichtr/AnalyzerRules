
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
function Select-RuleViolation {
    <#
    .SYNOPSIS
        Retrieve the AST items that match the given filter
    #>
    [CmdletBinding()]
    param(
        # The AST to search
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [AST]$Ast,

        # The filter script to use
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Predicate')]
        [scriptblock]$Filter,

        # Optionally recurse into children
        [Parameter(
        )]
        [switch]$Recurse,

        # Specify number of items from the beginning
        [Parameter(
        )]
        [int]$First,

        # Specify number of items from the end
        [Parameter(
        )]
        [int]$Last,

        # Skip the number of items specified
        [Parameter(
        )]
        [int]$Skip
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $selectOptions = @{}
    }
    process {

        if ($PSBoundParameters.ContainsKey('First')) {
            $selectOptions['First'] = $First
        }
        if ($PSBoundParameters.ContainsKey('Last')) {
            $selectOptions['Last'] = $Last
        }
        if ($PSBoundParameters.ContainsKey('Skip')) {
            $selectOptions['Skip'] = $Skip
        }



        if ($selectOptions.Keys.Count -gt 0) {
            $Ast.FindAll($Filter, [bool]$Recurse) | Select-Object @options
        } else {
            $Ast.FindAll($Filter, [bool]$Recurse)
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
