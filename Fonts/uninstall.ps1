$PackageName = "Company-Fonts"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\uninstall\$PackageName-uninstall.log" -Force

$WorkingPath = "$Path_local\Data\Fonts"
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

Remove-Item -Path "$Path_local\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript
