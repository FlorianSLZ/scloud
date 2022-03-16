# Module by https://github.com/jseerden/IntuneBackupAndRestore
Install-Module -Name IntuneBackupAndRestore -Scope CurrentUser
Install-Module -Name Microsoft.Graph.Intune -Scope CurrentUser

$BackupPath = Read-Host "Backup path"

Connect-MSGraph
Import-Module IntuneBackupAndRestore

Start-IntuneBackup -Path $BackupPath
Invoke-IntuneRestoreDeviceConfiguration -Path $BackupPath


# To backup your own: Invoke-IntuneBackupDeviceConfiguration -Path $BackupPath