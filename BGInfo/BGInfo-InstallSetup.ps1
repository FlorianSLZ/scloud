## Variables
 
$bgInfoFolder = "$env:programfiles\BgInfo"
$bgInfoFolderContent = $bgInfoFolder + "\*"
$itemType = "Directory"
$bgInfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$logonBgiUrl = "https://github.com/FlorianSLZ/scloud/raw/main/BGInfo/scloud.bgi"
$bgInfoZip = "$bgInfoFolder\BgInfo.zip"
$bgInfoEula = "$bgInfoFolder\Eula.txt"
$logonBgiZip = "$bgInfoFolder\logon.bgi"
$bgInfoRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegkey = "BgInfo"
$bgInfoRegType = "String"
$bgInfoRegkeyValue = "$bgInfoFolder\Bginfo.exe $bgInfoFolder\logon.bgi /timer:0 /nolicprompt"
$regKeyExists = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
 
$foregroundColor1 = "Cyan"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download started
 
Write-Host ($writeEmptyLine + "# BgInfo download started") -foregroundcolor $foregroundColor1 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
## Create BgInfo folder on C: if it not exists, else delete it's content
 
If (!(Test-Path -Path $bgInfoFolder)){New-Item -ItemType $itemType -Force -Path $bgInfoFolder
    Write-Host ($writeEmptyLine + "# BgInfo folder created")`
    -foregroundcolor $foregroundColor2 $writeEmptyLine
 }Else{Write-Host ($writeEmptyLine + "# BgInfo folder already exists")`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
    Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host ($writeEmptyLine + "# Content existing BgInfo folder deleted") -foregroundcolor $foregroundColor1 $writeEmptyLine}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract latest BgInfo software to $bgInfoFolder
 
Import-Module BitsTransfer
Start-BitsTransfer -Source $bgInfoUrl -Destination $bgInfoZip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($bgInfoZip, $bgInfoFolder)
Remove-Item $bgInfoZip
Remove-Item $bgInfoEula
Write-Host ($writeEmptyLine + "# bginfo.exe available") -foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract logon.bgi file to $bgInfoFolder
 
Invoke-WebRequest -Uri $logonBgiUrl -OutFile $logonBgiZip
Write-Host ($writeEmptyLine + "# logon.bgi available") -foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create BgInfo Registry Key to AutoStart
 
If ($regKeyExists -eq $True){Write-Host ($writeEmptyLine + "# BgInfo regkey exists, script wil go on")`
-foregroundcolor $foregroundColor1 $writeEmptyLine
}Else{
New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
Write-Host ($writeEmptyLine + "# BgInfo regkey added")`
-foregroundcolor $foregroundColor2 $writeEmptyLine}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Run BgInfo
Start-Process "$bgInfoFolder\Bginfo.exe" -ArgumentList """$bgInfoFolder\logon.bgi"" /timer:0 /nolicprompt"
Write-Host ($writeEmptyLine + "# BgInfo has run") -foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Exit PowerShell window 3 seconds after completion
 
Write-Host ($writeEmptyLine + "# Script completed, the PowerShell window will close in 3 seconds") -foregroundcolor $foregroundColor1 $writeEmptyLine

 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------