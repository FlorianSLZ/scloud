$PackageName = "Company-Fonts"
$Version = "1"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force
try{

    $WorkingPath = "$Path_4netIntune\Data\Fonts"
    New-Item -ItemType "directory" -Path $WorkingPath -Force
    Copy-Item -Path ".\Fonts\*" -Destination $WorkingPath -Recurse

    $AllFonts = @()
    $AllFonts += Get-ChildItem -Path "$WorkingPath\*.ttf"
    $AllFonts += Get-ChildItem -Path "$WorkingPath\*.otf"

    foreach($FontFile in $AllFonts){
        try{
            Copy-Item -Path "$WorkingPath\$($FontFile.Name)" -Destination "$env:windir\Fonts" -Force -PassThru -ErrorAction Stop
            New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $FontFile.Name -PropertyType String -Value $FontFile.Name -Force
        }catch{
            Write-Host $_
        }
    }

    Remove-Item $WorkingPath -Force -Recurse

    New-Item -Path "$Path_4netIntune\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}
Stop-Transcript
