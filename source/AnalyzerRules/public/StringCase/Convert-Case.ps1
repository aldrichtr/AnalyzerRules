
using namespace System.Text
using namespace System.Collections
function Convert-Case {
    <#
    .SYNOPSIS
        Converter
    .DESCRIPTION
        In dot case, each word is lowercase, and they are separated by an underscore '.'
        - usb.port
        - remaining.values.in.collection
    #>
    [CmdletBinding()]
    param(
        # The phrase to convert
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string]$InputObject,

        # The case of the first word
        [Parameter(
        )]
        [ValidateSet('lower', 'upper', 'capital')]
        [string]$FirstWordCase,

        # The case of the words in the phrase
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [ValidateSet('lower', 'upper', 'capital')]
        [string]$WordCase,

        # The separator character between words
        [Parameter(
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$Separator
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $specialCharacters = @('$', '@', '#')
        $newWord = [StringBuilder]::new()
        $textInfo = (Get-Culture).TextInfo
    }
    process {
        # If the phrase starts with a special character, take it off the input,
        # ! but add it back onto the output
        if ($InputObject.Substring(0, 1) -in $specialCharacters) {
            [void]$newWord.Append($InputObject.Substring(0, 1))
            $InputObject = $InputObject.Substring(1)
        }
        $parts = [ArrayList]::new()

        ($InputObject | Split-Phrase)
        | ForEach-Object { [void]$parts.Add($_) }

        if ($PSBoundParameters.ContainsKey('FirstWordCase')) {
            switch ($FirstWordCase) {
                'upper' {
                    [void]$newWord.Append(
                        $textInfo.ToUpper($parts[0])
                    )
                }
                'lower' {
                    [void]$newWord.Append(
                        $textInfo.ToLower($parts[0])
                    )
                }
                'capital' {
                    [void]$newWord.Append(
                        $textInfo.ToTitleCase($parts[0])
                    )
                }
                default {
                    throw "$FirstWordCase is not a valid case"
                }
            }
            [void]$parts.RemoveAt(0)
        }

        switch ($WordCase) {
            'upper' {
                [void]$newWord.Append(
                    ($textInfo.ToUpper($parts) -replace ' ', ($Separator ?? ''))
                )
            }
            'lower' {
                [void]$newWord.Append(
                    ($textInfo.ToLower($parts) -replace ' ', ($Separator ?? ''))
                )
            }
            'capital' {
                [void]$newWord.Append(
                    ($textInfo.ToTitleCase($parts) -replace ' ', ($Separator ?? ''))
                )
            }
            default {
                throw "$WordCase is not a valid case"
            }
        }
        $newWord.ToString()
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
