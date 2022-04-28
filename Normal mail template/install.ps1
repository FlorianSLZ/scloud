$PackageName = "NormalEmail-template"
$Version = "1"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-$env:USERNAME-install.log" -Force
$ErrorActionPreference = "Stop"

$NormalEmail_File = "$env:APPDATA\Microsoft\Templates\NormalEmail.dotm"

try{
    New-Item -Path "$env:APPDATA\Microsoft\Templates" -ItemType "Directory" -Force
    try{
        if(Test-Path $NormalEmail_File){Remove-Item -Path $NormalEmail_File -Force}
        Copy-Item 'NormalEmail.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force
    }catch{
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show('Your Outlook needs an Update with a restart. Please press OK to restart Outlook')
        Get-Process Outlook | Stop-Process -Force
        Start-Sleep 5
        if(Test-Path $NormalEmail_File){Remove-Item -Path $NormalEmail_File -Force}
        Copy-Item 'NormalEmail.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force
        Start-Process Outlook
    }
    # Validation file
    New-Item -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
