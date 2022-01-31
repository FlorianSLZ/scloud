$ProgramName = "PROGRAMNAME"
$ProgramPath = "C:\Program Files\PROGRAMNAME\start.exe"
$ProgramVersion_target = '10.1'
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -eq $ProgramVersion_target){
    Write-Host "Found it!"
}