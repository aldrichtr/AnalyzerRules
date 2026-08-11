
using namespace System.Management.Automation.Language
function ConvertTo-ScriptExtent {
  <#
    .SYNOPSIS
        Convert the given inputs into a ScriptExtent
    #>
  [OutputType([System.Management.Automation.Language.ScriptExtent])]
  [CmdletBinding()]
  param(
    # The Ast with the extent we want to Convert
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName
    )]
    [IScriptExtent]$Extent

  )
  process {
    # SECTION StartPosition

    $startPos = $Extent.StartScriptPosition

    $convertedStart = [ScriptPosition]::new(
      $startPos.File,
      $startPos.LineNumber,
      $startPos.ColumnNumber,
      $startPos.Line,
      $startPos.GetFullScript())
    # !SECTION

    # SECTION EndPosition

    $endPos = $Extent.EndScriptPosition

    $convertedEnd = [ScriptPosition]::new(
      $endPos.File,
      $endPos.LineNumber,
      $endPos.Offset,
      $endPos.Line,
      $endPos.GetFullScript())
    # !SECTION

    # SECTION New ScriptExtent
    try {
      $newExtent = [ScriptExtent]::new($convertedStart, $convertedEnd)
    } catch {
      throw "Could not create new ScriptExtent`n$_"
    }
    # !SECTION

    $newExtent
  }
}
