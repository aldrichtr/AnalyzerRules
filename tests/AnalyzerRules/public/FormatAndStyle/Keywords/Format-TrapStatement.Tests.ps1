
using namespace System.Management.Automation.Language


$options = @{
  Name    = 'GIVEN the public function Format-TrapStatement'
  Tag     = @( 'unit', 'FormatAndStyle', 'Keywords', 'Format', 'TrapStatement')
}
Describe @options {
  <# --=-- #>
  Context 'SCENARIO: Use the function to analyze scriptblocks' {
    Context 'GIVEN that we pass a scriptblock to Format-TrapStatement outside ScriptAnalyzer' `
      -Tag @('Raw') -ForEach @(
      @{
        ScriptBlock = @'
{ TRAP { Write-Warning "Yikes, a trap!"}}
'@
        ResultCount = 1
      }
    ) {
      BeforeAll {
        Mock Get-RuleSetting -ModuleName AnalyzerRules -MockWith {
          return @{
            Enabled = $true
            Case    = 'lower'
          }
        }

        $scriptAst = ConvertTo-Ast $ScriptBlock
        $trapAst = $scriptAst.Find({ param($ast) $ast -is [TrapStatementAst] }, $true)
        $result = Format-TrapStatement -InputAst $trapAst
      }
      It 'It should have <ResultCount> Results' {
        $result.Count | Should -Be $ResultCount
      }
    }

    Context 'When ScriptAnalyzer is called with <AnalyzerOptions.IncludeRule>' -ForEach @(
      @{
        AnalyzerOptions = @{
          ScriptDefinition      = @'
function Test-CaseOfTrap {
[CmdletBinding()]
param()
begin {}
process { Trap { Write-Warning "Yikes, a trap!"}}
}
'@
          CustomRulePath        = 'stage'
          RecurseCustomRulePath = $true
          IncludeDefaultRules   = $false
          IncludeRule           = 'Format-TrapStatement'
          Settings              = @{
            Rules = @{
              FormatTrapStatement = @{
                Enabled = $true
                Case    = 'lower'
              }
            }
          }
        }
        ResultCount     = 1
      },
      @{
        AnalyzerOptions = @{
          ScriptDefinition      = @'
function Test-CaseOfTrap1 {
[CmdletBinding()]
param()
begin {}
process { TRAP { Write-Warning "Yikes, a trap!"}}
}
'@
          CustomRulePath        = 'stage'
          RecurseCustomRulePath = $true
          IncludeDefaultRules   = $false
          IncludeRule           = 'Format-TrapStatement'
          Settings              = @{
            Rules = @{
              FormatTrapStatement = @{
                Enabled = $true
                Case    = 'lower'
              }
            }
          }
        }
        ResultCount     = 1
      }
    ) {
      BeforeEach {
        $result = Invoke-ScriptAnalyzer @AnalyzerOptions
      }

      It 'It should have a result count of <ResultCount>' {
        $result.Count | Should -Be $ResultCount
      }

    }
  }

  <# --=-- #>
}
