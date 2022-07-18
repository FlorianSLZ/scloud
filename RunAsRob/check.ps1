######################################################################################################################
# Program EXE with target Version or higher
######################################################################################################################
$ProgramPath = "C:\Program Files\RunasRob\runasrob.exe"
$ProgramVersion_target = '4.2.0.0' 
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -ge [System.Version]$ProgramVersion_target){
    Write-Host "Found it!"
}
