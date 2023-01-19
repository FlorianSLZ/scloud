Get-AppXPackage *Microsoft.Windows.Search* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *MicrosoftWindows.Client.CBS* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *Microsoft.Windows.ShellExperienceHost* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *Microsoft.AAD.BrokerPlugin* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}
Get-AppXPackage *Microsoft.AccountsControl* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}

Get-AppXPackage *Microsoft.Windows.CloudExperienceHost* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}


# addition
Add-AppxPackage -register "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\appxmanifest.xml" -DisableDevelopmentMode

Get-AppXPackage *Microsoft.Windows.ShellExperienceHost* |
ForEach-Object {
Add-AppxPackage -DisableDevelopmentMode -ForceApplicationShutdown -Register "$($_.InstallLocation)\AppXManifest.xml"
}