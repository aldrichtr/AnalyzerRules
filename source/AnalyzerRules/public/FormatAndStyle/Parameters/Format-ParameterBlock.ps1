
using namespace System.Collections
using namespace System.Management.Automation.Language
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic

function Format-ParameterBlock {
  <#
    .SYNOPSIS
        Format a `[Parameter()]` block according to style rules
    .DESCRIPTION
        - ParameterSetName
        - Mandatory
        - Position
        - DontShow
        - ValueFromPipeline
        - ValueFromPipelineByPropertyName
        - ValueFromRemainingArguments
        - HelpMessage
        - HelpMessageBaseName
        - HelpMessageResourceId
    #>
  [CmdletBinding()]
  [OutputType([DiagnosticRecord[]])]
  param(
    [Parameter(
      Mandatory,
      ValueFromPipeline
    )]
    [ValidateNotNullOrEmpty()]
    [ScriptBlockAst]$InputAst
  )
  begin {
    $self = $MyInvocation.MyCommand
    $ruleName = $self | Select-RuleName

    # SECTION Category Settings

    # !SECTION Category Settings

    # SECTION defaults

    <#
         The default setting is to separate Arguments on separate lines:
         ParameterSetName = 'Default',
         Mandatory
        #>
    # TODO(Refactor): Change the Separator in settings to 'CR', 'CRLF', 'SPACE'
    $separator = "`n"

    <#
     The default is to omit the '= $true' expression on arguments
    #>
    $useTrueExpression = $false
    <#
     The default is to omit the argument if the expression is '= $false'
     #>
    $useFalseExpression = $false

    <#
     if useFalseExpression is $true,
       Exclude the following arguments if $false
     #>
    $excludeFalseExpression = @(
      'HelpMessage',
      'HelpMessageBaseName',
      'HelpMessageResourceId'
    )

    $argumentList = @(
      'ParameterSetName',
      'Mandatory',
      'Position',
      'DontShow',
      'ValueFromPipeline',
      'ValueFromPipelineByPropertyName',
      'ValueFromRemainingArguments',
      'HelpMessage',
      'HelpMessageBaseName',
      'HelpMessageResourceId'
    )
    # !SECTION defaults
    #-------------------------------------------------------------------------------

    $settings = Get-RuleSetting $ruleName

    if ($null -ne $settings) {
      # because the rule setting is 'useNewLine', if it is true (the default),
      # then Arguments are separated by new lines, if not, then use a space
      if (-not($settings.useNewLine)) {
        $separator = ' '
      }
      if ($settings.ContainsKey('useTrueExpression')) {
        $useTrueExpression = $settings.useTrueExpression
      }
      if ($settings.ContainsKey('useFalseExpression')) {
        $useFalseExpression = $settings.useFalseExpression
      }
      if ($settings.ContainsKey('excludeFalseExpression')) {
        $excludeFalseExpression = $settings.excludeFalseExpression
      }
      # allow the user to re-order the arguments
      if ($settings.ContainsKey( 'argumentOrder' )) {
        $order = $settings.argumentOrder

        if ($order.Count -gt 0) {
          # add any missing arguments to the bottom of the list
          foreach ($a in $argumentList) {
            # if the argument is not in the list already
            if ($order -notcontains $a) {
              # if we are adding Falses
              # but not if they are excluded
              if (($useFalseExpression) -and ($excludeFalseExpression -notcontains $a)) {
                $order += $a
              }
            }
          }
        }
        $argumentList = $order
      }
    }
    $listJoinCharacter = ",$separator"
    # !SECTION RuleSettings
    #-------------------------------------------------------------------------------

    [scriptblock]$predicate = {
      param( [Parameter()] [Ast]$Ast)
      (
        ($Ast -is [AttributeAst]) -and
        ($Ast.TypeName -like 'Parameter')
      )
    }
  }
  process {
    try {
      $violations = $InputAst | Select-RuleViolation $predicate
    } catch {
      $err = $_ # The original error
      $message = 'There was an error parsing'
      $exceptionText = ( @($message, $err.ToString()) -join "`n")
      $newException = [Exception]::new($exceptionText)
      $eRecord = [System.Management.Automation.ErrorRecord]::new(
        $newException,
        $err.FullyQualifiedErrorId,
        $err.CategoryInfo.Category,
        $InputAst
      )
      $PSCmdlet.ThrowTerminatingError( $eRecord )
    }

    if ($violations.Count -gt 0) {
      $results = New-DiagnosticRecordCollection


      :violation foreach ($violation in $violations) {

        $extent = $violation.extent
        $replacementList = [ArrayList]::new()
        #! by looping through the argumentList, we can build the
        #! replacementList in order
        :argument foreach ($argument in $argumentList) {
          # is this argument even listed in the ScriptBlock?
          $found = $violation.NamedArguments |
            Where-Object ArgumentName -Like $argument

          if ($null -ne $found) {
            $indent = $extent.Text | Get-Indent $argument
            # yes, it is present
            # - does it have an expression? (an '= ?')
            if ($found.ExpressionOmitted -eq $false) {
              # yes, it has an expression
              # - is the expression '= $true'
              if ($found.Argument -like '$true') {
                # yes, the expression is '= $true'
                #  - do we need to set it in the correction?
                if ($useTrueExpression) {
                  # yes, we need to set it
                  $null = $replacementList.Add("$indent$($found.ArgumentName) = `$true")
                } else {
                  # no, do not set it
                  $null = $replacementList.Add("$indent$($found.ArgumentName)")
                }
                # - is the expression '= $false' and do we need to set it?
              } elseif ($found.Argument -like '$false') {
                if ($useFalseExpression) {
                  # yes, it is '= $false' and we need to set it
                  $null = $replacementList.Add("$indent$($found.ArgumentName) = `$false")
                }
                # - is the expression something other than '$true' and '= $false'
              } else {
                # yes, it is not true or false, we need to set it
                $null = $replacementList.Add("$indent$($found.ArgumentName) = $($found.Argument)")
              }
            } else {
              # no, it does not have an expression
              # - do we need to set the true expression?
              if ($useTrueExpression) {
                # yes, we need to set it
                $null = $replacementList.Add("$indent$($found.ArgumentName) = `$true")
              } else {
                # no, we do not need to set it
                $null = $replacementList.Add("$indent$($found.ArgumentName)")
              }
            }
          } else {
            # it was in the argumentList, but was not in the list of arguments
            # in the scriptblock, so we add it here if we are using false
            if ($useFalseExpression) {
              $null = $replacementList.Add("$($found.ArgumentName) = `$false")
            }
          }
        }

        $head = [regex]::Escape('[Parameter(')
        $foot = [regex]::Escape(')]')
        $hindent = $extent | Get-Indent -Argument $head
        $findent = $extent | Get-Indent -Argument $foot

        $heading = "$hindent$head"
        $footing = "$findent$foot"

        $correctionOptions = @{
          ReplacementText = (@(
              $heading,
              $separator,
              ($replacementList -join $listJoinCharacter),
              $separator,
              $footing
            ) -join '')
          Description     = 'Format the parameter block correctly'
        }

        $correction = $extent | New-Correction @correctionOptions

        $options = @{
          RuleName             = $ruleName
          Severity             = [RuleSeverity]'Warning'
          Message              = 'Parameter attributes are true if present false if not'
          Extent               = $extent
          SuggestedCorrections = $correction
        }
        $results += (New-PSSADiagnosticRecord @options)
      } # end foreach violation
    } # end if violations
  } end {
    $results
  }
}
