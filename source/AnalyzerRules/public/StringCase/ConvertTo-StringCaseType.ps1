
function ConvertTo-StringCaseType {
    <#
    .SYNOPSIS
        Convert a string value into the appropriate [StringCase]
    #>
    [CmdletBinding()]
    param(
      # The name of the case to convert to a [StringCase]
      [Parameter(
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
      )]
      [string]$Case
    )
    begin {
      $self = $MyInvocation.MyCommand
        Write-Debug "`n$('-' * 80)`n-- Begin $($self.Name)`n$('-' * 80)"
    }
    process {
        switch -Regex ($Case) {
            # NOTE: Transfer the setting to the StringCase enum
            # case insensitive by default, so the settings can be 'lower', 'Lower', etc.
            '^up'     { return [StringCase]::Upper    }
            '^low'    { return [StringCase]::Lower    }
            '^cap'    { return [StringCase]::Capital  }
            '^camel'  { return [StringCase]::Camel    }
            '^pascal' { return [StringCase]::Pascal   }
            '^snake'  { return [StringCase]::Snake    }
            '^kebab'  { return [StringCase]::Kebab    }
            '^dot'    { return [StringCase]::Dot      }
            '^const'  { return [StringCase]::Constant }
            '^train'  { return [StringCase]::Train    }
            '^cobol'  { return [StringCase]::Cobol    }

            default {
             throw "'$Case' is not a valid string case type"
            }
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($self.Name)`n$('-' * 80)"
    }
}
