$ProgramName = "makemeadmin"

$Path_local = "$Env:Programfiles\_MEM" 
Start-Transcript -Path "$Path_local\Log\uninstall\$ProgramName-uninstall.log" -Force

try{
    $MSICode = $(Get-Package -Name "Make Me Admin").FastPackageReference
    Start-Process msiexec.exe -Argument "/x $MSICode /qn" -Wait
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR while uninstalling $PackageName"
    Write-Host "$_"
}

Stop-Transcript
