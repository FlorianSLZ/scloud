# Install Modules in user context
Install-Module NuGet, IntuneWin32App, AzureAD -Scope CurrentUser -Force

# change base64 convertion
$oldLine = '$ScriptContent = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllBytes("$($ScriptFile)") -join [Environment]::NewLine))'
$newLine = '$ScriptContent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$($ScriptFile)"))'
$File = "$([Environment]::GetFolderPath("MyDocuments"))\WindowsPowerShell\Modules\IntuneWin32App\1.3.3\Public\New-IntuneWin32AppDetectionRuleScript.ps1"
(Get-Content $File).Replace($oldLine,$newLine) | Set-Content $File
