
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

function Select-RuleViolation {
    <#
    .SYNOPSIS
        Retrieve the AST items that match the given filter
    .DESCRIPTION
      Select-RuleViolation is the main *filtering function* of the AnalyzerRules module.  It takes an Ast and a
      function that acts as a filter to identify violations.  Violations of the given filter (those AST objects that
      match the function) are returned on the pipeline.
    .EXAMPLE
      $ScriptBlockAst | Select-RuleViolation {param([Parameter()][Ast]$Ast)
        $Ast.Extent.Text -match '^foo'}
    #>
    [CmdletBinding()]
    param(
        # The filter script to use. This is a scriptblock that returns `$true` or `$false`.  All AST elements where
        # the result is `$true` will be returned by this function.
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Predicate')]
        [scriptblock]$Filter,

        # The AST that will be searched by `$Filter`
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [AST]$Ast,

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
        $selectOptions = @{ }
        $keys = @('First', 'Last', 'Skip')
      }
      process {
       # --------------------------------------------------------------------------------
       # #region transfer options
       foreach ($key in $keys) {
        if ($PSBoundParameters.ContainsKey($key)) {
            $selectOptions[$key] = $PSBoundParameters[$key]
        }
       }
       # #endregion transfer options
       # --------------------------------------------------------------------------------

        if ($selectOptions.Keys.Count -gt 0) {
            $Ast.FindAll($Filter, [bool]$Recurse)
            | Select-Object @$selectOptions
        } else {
            $Ast.FindAll($Filter, [bool]$Recurse)
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
