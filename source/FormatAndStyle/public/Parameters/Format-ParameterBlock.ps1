function Format-ParameterAttributeBlock {
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
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [ScriptBlockAst]$ScriptBlockAst
    )
    begin {
        #-------------------------------------------------------------------------------
        #region Setup
        $ruleName = (Format-RuleName)

        $results = New-DiagnosticRecordCollection
        $corrections = New-CorrectionCollection
        $ruleArgs = Get-RuleSetting

        #endregion Setup
        #-------------------------------------------------------------------------------

        #-------------------------------------------------------------------------------
        #region defaults

        <#
         The default setting is to separate Arguments on separate lines:
         ParameterSetName = 'Default',
         Mandatory
        #>
        #TODO(Refactor): Change the Separator in settings to 'CR', 'CRLF', 'SPACE'
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
        #endregion defaults
        #-------------------------------------------------------------------------------

        if ($null -ne $ruleArgs) {
            # because the rule setting is 'useNewLine', if it is true (the default),
            # then Arguments are separated by new lines, if not, then use a space
            if (-not($ruleArgs.useNewLine)) {
                $separator = ' '
            }
            if ($ruleArgs.ContainsKey('useTrueExpression')) {
                $useTrueExpression = $ruleArgs.useTrueExpression
            }
            if ($ruleArgs.ContainsKey('useFalseExpression')) {
                $useFalseExpression = $ruleArgs.useFalseExpression
            }
            if ($ruleArgs.ContainsKey('excludeFalseExpression')) {
                $excludeFalseExpression = $ruleArgs.excludeFalseExpression
            }
            # allow the user to re-order the arguments
            if ($ruleArgs.ContainsKey( 'argumentList' )) {
                $newList = $ruleArgs.argumentList

                if (($newList.Count -gt 0) -and ($newList.Count -lt 10)) {
                    # add any missing arguments to the bottom of the list
                    foreach ($a in $argumentList) {
                        # if the argument is not in the list already
                        if ($newList -notcontains $a) {
                            # if we are adding Falses
                            # but not if they are excluded
                            if (($useFalseExpression) -and ($excludeFalseExpression -notcontains $a)) {
                                $newList += $a
                            }
                        }
                    }
                }
                $argumentList = $newList
            }
        }
        $listJoinCharacter = ",$separator"
        #endregion RuleSettings
        #-------------------------------------------------------------------------------

        $findParameter = {
            param(
                [Parameter()]
                [Ast]$Ast
            )
            (
                ($Ast -is [AttributeAst]) -and
                ($Ast.TypeName -like 'Parameter')
            )
        }
    }
    process {
        try {
            $parameterBlocks = $ScriptBlockAst | Select-RuleViolation $findParameter

            foreach ($parameterBlock in $parameterBlocks) {

                $extent = $parameterBlock.extent
                $replacementList = @()
                #! by looping through the argumentList, we can build the
                #! replacementList in order
                foreach ($argument in $argumentList) {
                    # is this argument even listed in the ScriptBlock?
                    $found = $parameterBlock.NamedArguments
                    | Where-Object ArgumentName -Like $argument
                    $indent = Get-Indent -Argument $argument -Extent $extent.Text
                    if ($null -ne $found) {
                        #yes, it is present
                        # - does it have an expression? (an '= ?')
                        if ($found.ExpressionOmitted -eq $false) {
                            # yes, it has an expression
                            # - is the expression '= $true'
                            if ($found.Argument -like '$true') {
                                # yes, the expression is '= $true'
                                #  - do we need to set it in the correction?
                                if ($useTrueExpression) {
                                    # yes, we need to set it
                                    $replacementList += "$indent$($found.ArgumentName) = `$true"
                                } else {
                                    # no, do not set it
                                    $replacementList += "$indent$($found.ArgumentName)"
                                }
                                # - is the expression '= $false' and do we need to set it?
                            } elseif ($found.Argument -like '$false') {
                                if ($useFalseExpression) {
                                    # yes, it is '= $false' and we need to set it
                                    $replacementList += "$indent$($found.ArgumentName) = `$false"
                                }
                                # - is the expression something other than '$true' and '= $false'
                            } else {
                                # yes, it is not true or false, we need to set it
                                $replacementList += "$indent$($found.ArgumentName) = $($found.Argument)"
                            }
                        } else {
                            # no, it does not have an expression
                            # - do we need to set the true expression?
                            if ($useTrueExpression) {
                                # yes, we need to set it
                                $replacementList += "$indent$($found.ArgumentName) = `$true"
                            } else {
                                # no, we do not need to set it
                                $replacementList += "$indent$($found.ArgumentName)"
                            }
                        }
                    } else {
                        # it was in the argumentList, but was not in the list of arguments
                        # in the scriptblock, so we add it here if we are using false
                        if ($useFalseExpression) {
                            $replacementList += "$($found.ArgumentName) = `$false"
                        }
                    }
                }
                # if the argument is in the scriptblock, and we are not setting false expressions
                # it is omitted

                # if the argument is in the scriptblock and it is not in the argumentList
                # it is omitted
                # TODO: is that ok?
                $head = [regex]::Escape('[Parameter(')
                $foot = [regex]::Escape(')]')
                $hindent = Get-Indent -Argument $head -Extent $extent.Text
                $findent = Get-Indent -Argument $foot -Extent $extent.Text

                $heading = "$hindent$head"
                $footing = "$findent$foot"
                $replacement = ( -join @(
                        $heading,
                        $separator,
                    ($replacementList -join $listJoinCharacter),
                        $separator,
                        $footing
                    ))
                    # Compare the two strings, disregard whitespace
                if (-not(Compare-Object $extent.Text.Trim() $replacement.Trim())) {
                    $corrections += ($extent | New-PssaCorrection -ReplacementText $replacement)

                    $options = @{
                        Message              = 'Parameter attributes are true if present false if not'
                        Severity             = 'Warning'
                        Extent               = $extent
                        SuggestedCorrections = $corrections
                    }
                    $results += (New-PSSADiagnosticRecord @options)
                }
            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
    end {
        $results
    }
}
