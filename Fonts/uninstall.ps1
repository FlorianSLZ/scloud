$PackageName = "Company-Fonts"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-install.log" -Force

$WorkingPath = "$Path_4netIntune\Data\Fonts"
New-Item -ItemType "directory" -Path $WorkingPath -Force
Copy-Item -Path ".\Fonts\*" -Destination $WorkingPath -Recurse

$AllFonts = Get-ChildItem -Path "$WorkingPath\*.ttf"
$AllFonts += Get-ChildItem -Path "$WorkingPath\*.otf"

foreach($FontFile in $AllFonts){
    try{
        Remove-Item -Path "$WorkingPath\$($FontFile.Name)" -Force
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $FontFile.Name -Force
    }catch{
        Write-Host $_
    }
}

Remove-Item $WorkingPath -Force -Recurse

Remove-Item -Path "$Path_4netIntune\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript
