$WorkingPath = "C:\Admin\Intune\Fonts"
New-Item -ItemType "directory" -Path $WorkingPath -Force
Copy-Item -Path ".\Schriften\*" -Destination $WorkingPath -Recurse

$AllFonts = Get-ChildItem -Path "$WorkingPath\*.ttf"
$AllFonts += Get-ChildItem -Path "$WorkingPath\*.otf"

foreach($FontFile in $AllFonts){
    try{
        Remove-Item -Path "$env:windir\Fonts\$($FontFile.Name)" -Force
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $FontFile.Name -Force
    }catch{
        Write-Error $_
    }
}

Remove-Item -Path $WorkingPath -Recurse -Force
