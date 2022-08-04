$ProgramName = "WorksheetCrafter"
$ProgramPath = "C:\Program Files (x86)\Worksheet Crafter\WorksheetCrafter.exe"
$ProgramVersion_target = '2022.2.7.135'
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -ge [System.Version]$ProgramVersion_target){
    Write-Host "Found it!"
}