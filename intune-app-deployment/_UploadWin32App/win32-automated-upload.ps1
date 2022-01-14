<#
Install-Module -Name IntuneWin32App -Force
Install-Module Microsoft.Graph -Force
#>
Import-Module -Name IntuneWin32App

# Initial Variabeln
$TenantPrefix = Read-Host "Tenant-Prefix (exp. scloudwork at scloudwork.onmicrosoft.com)"
$TenantID = "$TenantPrefix.onmicrosoft.com"
$Publisher = "scloud.work" # Change this with your organisations name
$Repo_Path = Read-Host "Software-Repo Path"
$CSV_Path = "$Repo_Path\Software-list.csv"

#Connect-AzureAD
Connect-MSIntuneGraph -TenantID $TenantID

#Select Appliacations
$Applications = Import-Csv -Path $CSV_Path -Delimiter ";" -Encoding UTF8
$selectedApplications =  $Applications | Out-GridView -OutputMode Multiple -Title "Select Applications to create"


foreach($Application in $selectedApplications){
    Write-Host "(i) Verarbeitung der Applikation $($Application.Name)" -ForegroundColor Cyan
    try{
        
        # Graph Connect 
        Connect-MSIntuneGraph -TenantID $TenantID

        # create .intunewin for Upload 
        $IntuneWinFile = "$Repo_Path\$($Application.Name)\install.intunewin"

        # read Displayname 
        $DisplayName = "$($Application.Name)"

        # create detection rule
        $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$Repo_Path\$($Application.Name)\check.ps1" -EnforceSignatureCheck $false -RunAs32Bit $false

        # minimum requirements
        $RequirementRule = New-IntuneWin32AppRequirementRule -Architecture x64 -MinimumSupportedOperatingSystem 2004

        # picture for win32 app (shown in company portal)
        $ImageFile = "$Repo_Path\$($Application.Name)\$($Application.Name).png"
        $Icon = New-IntuneWin32AppIcon -FilePath $ImageFile

        # Dependenci (if present)
        if($Application.Dependency){
            $DependendProgram = Get-IntuneWin32App | where {$_.DisplayName -eq $Application.Dependency} | select id
            $Dependency = New-IntuneWin32AppDependency -id $DependendProgram.id -DependencyType AutoInstall 
        }

        # Upload 
        $InstallCommandLine = $Application.install
        $UninstallCommandLine = $Application.uninstall
        if($Application.Dependency){
            Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description $($Application.description) -Publisher $Publisher -InstallExperience $($Application.as) -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon -AdditionalRequirementRule $Dependency
        }else{
            Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description $($Application.description) -Publisher $Publisher -InstallExperience $($Application.as) -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon        
        }
    }
    catch{
        Write-Host "Error Application $($Application.Name)" -ForegroundColor Red
        $_
    }
    # Sleep to prevent block from azure on a mass upload
    Start-sleep -s 15

}

