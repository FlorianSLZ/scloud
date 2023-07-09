Param
  (
    [parameter(Mandatory=$true)]
    [String[]]
    $param
  )
  
$PackageName = "WorksheetCrafter"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

Start-Process 'Worksheet_Crafter_Setup_Full.exe' -ArgumentList $param -Wait


Stop-Transcript



