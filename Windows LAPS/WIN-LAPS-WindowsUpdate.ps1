Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\LAPS-WindowsUpdate-script.log" -Force


Install-PackageProvider -Name NuGet -Force
Install-Module PSWindowsUpdate -Force

$WindowsInfo = Get-ComputerInfo | Select-Object OSName, OSVersion


if($WindowsInfo.OSName -like "*10*"){
	Write-Host "Windows 10 update for LAPS"
	Get-WindowsUpdate -Install -KBArticleID 'KB5025221'
}
elseif($WindowsInfo.OSName -like "*11*"){
	Write-Host "Windows 11 update for LAPS"
	Get-WindowsUpdate -Install -KBArticleID 'KB5025239'
}



Stop-Transcript