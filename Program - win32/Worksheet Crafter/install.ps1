Param
  (
    [parameter(Mandatory=$true)]
    [String[]]
    $param
  )
  
$PackageName = "WorksheetCrafter"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

Start-Process 'Worksheet_Crafter_Setup_Full.exe' -ArgumentList $param -Wait


Stop-Transcript



