$ProgramPath = "C:\Program Files\HPImageAssistant\HPImageAssistant.exe"
$ProgramVersion_target = '5.1.7.138' 
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -eq $ProgramVersion_target){
    Write-Host "Found it!"
}
