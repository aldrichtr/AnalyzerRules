
function Split-Phrase {
    <#
    .SYNOPSIS
        Split a word or phrase into its parts
    .DESCRIPTION
        `Split-Phrase` wil split a phrase (words separated by space ' ' )or a word in:
        - camelCase
        - PascalCase
        - snake_case
        - kebab-case
        - dot.case
    .EXAMPLE
        Split-Phrase 'thisIsCamelCase'

        this
        Is
        Camel
        Case
    .NOTES
        `Split-Phrase` will ignore the starting variable symbols ('$' or '@').  If the phrase could not be split,
        it will be returned as is, **with the exception that the preceding '$' or '@' is dropped.**
    #>
    [CmdletBinding()]
    param(
        # The word to input
        [Parameter(
            ValueFromPipeline
        )]
        [string]$InputObject
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $specialCharacters = @('$', '@')
        $replacePattern = (@(
                '(?<=[A-Z])(?-[A-Z][a-z])', # UC before me, UC lc after me
                '|(?<=[^A-Z])(?=[A-z])', # Not US before me, UC after me
                '|(?<=[A-Za-z])(?=[^A-Za-z])' # Letter before me, non-Letter after me
            ) -join '')
    }
    process {
        if ($InputObject.Substring(0, 1) -in $specialCharacters) {
            #! Remove the first character
            $InputObject = $InputObject.Substring(1)
        }

        if ($InputObject.Contains(' ')) {
            ($InputObject -split ' ')
        } elseif ( $InputObject | Test-CamelCase) {
            (($InputObject -creplace $replacePattern, ' ') -split ' ')
        } elseif ( $InputObject | Test-PascalCase) {
            (($InputObject -creplace $replacePattern, ' ') -split ' ')
        } elseif ( $InputObject | Test-SnakeCase) {
            ($InputObject -csplit '_')
        } elseif ( $InputObject | Test-KebabCase) {
            ($InputObject -csplit '-')
        } elseif ( $InputObject | Test-DotCase) {
            ($InputObject -csplit '\.')
        } else {
            # if none of those worked, just return what we had to begin with
            #! unless there was a symbol at the start, which got removed
            $InputObject
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
