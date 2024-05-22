
function Format-RuleName {
    <#
    .SYNOPSIS
        Format the rule name based on the calling function
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        $fullName = $FunctionName -replace '<.*>$', ''
        $verb, $noun = $fullName -split '-', 2

        switch -Regex ($verb) {
            '^Format' {
                # A rule function that is intended to format PowerShell source
                switch -Regex ($noun) {
                    '^Place' {
                        $shortName = $noun
                    }
                    default {
                        $shortName = ($verb, $noun) -join ''
                    }
                }
            }
            '^Measure' {
                switch ($noun) {
                    default { $shortName = $noun }
                }
            }
        }

        [PSCustomObject]@{
            PSTypeName = 'Analyzer.RuleName'
            FunctionName = $FunctionName
            ShortName = $shortName
            Verb = $verb
            Noun = $noun
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
