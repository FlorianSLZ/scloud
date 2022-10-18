$ProgramPath = "C:\Program Files\Make Me Admin\MakeMeAdminService.exe"
$ProgramVersion_target = '2.3.0.0' 
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -ge [System.Version]$ProgramVersion_target){
    Write-Host "Found it!"
}