
using namespace System

class RuleCategory : Attribute {
  [string]$Name

  RuleCategory([string]$n) {
    $this.Name = $n
  }

  # TODO[epic=Testing] Test the lookup of default settings
  # TODO[epic=Settings] Need to document the settings hierarchy
  [hashtable] Settings() {
    $setting = Get-RuleSetting $this.Name
    if ($null -eq $setting) {
      $setting = $null
    }
    return $setting
  }

    [void] Settings([hashtable]$s) {
      $mySettings = @{}
      $mySettings[$this.Name] = $s
      $mySettings | Add-RuleSetting
    }

}
