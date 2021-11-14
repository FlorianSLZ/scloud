$PackageName = "Fonts"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

$WorkingPath = "$Path_4netIntune\Data\Fonts"
New-Item -ItemType "directory" -Path $WorkingPath -Force
Copy-Item -Path ".\Schriften\*" -Destination $WorkingPath -Recurse

$AllFonts = Get-ChildItem -Path "$WorkingPath\*.ttf"
$AllFonts += Get-ChildItem -Path "$WorkingPath\*.otf"

foreach($FontFile in $AllFonts){
    try{
        Copy-Item -Path "$WorkingPath\$($FontFile.Name)" -Destination "$env:windir\Fonts" -Force -PassThru -ErrorAction Stop
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $FontFile.Name -PropertyType String -Value $FontFile.Name -Force
    }catch{
        Write-Host $_
    }
}

New-Item -Path "$Path_4netIntune\Log\Validation\$PackageName" -ItemType "file" -Force

Stop-Transcript
