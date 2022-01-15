$ErrorActionpreference = "stop"

# Functions
function Add-TheWin32App([Array] $App2upload){

    Write-Host "Processing application $($App2upload.Name)" -ForegroundColor Cyan
    try{
        
        # Graph Connect 
        $Session = Connect-MSIntuneGraph -TenantID $TenantID

        # get .intunewin for Upload 
        $IntuneWinFile = "$Repo_Path\$($App2upload.Name)\install.intunewin"

        # read Displayname 
        $DisplayName = "$($App2upload.Name)"

        # create detection rule
        $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$Repo_Path\$($App2upload.Name)\check.ps1" -EnforceSignatureCheck $false -RunAs32Bit $false

        # minimum requirements
        $RequirementRule = New-IntuneWin32AppRequirementRule -Architecture x64 -MinimumSupportedOperatingSystem 2004

        # picture for win32 app (shown in company portal)
        $ImageFile = "$Repo_Path\$($App2upload.Name)\$($App2upload.Name).png"
        $Icon = New-IntuneWin32AppIcon -FilePath $ImageFile

        # Upload 
        $InstallCommandLine = $App2upload.install
        $UninstallCommandLine = $App2upload.uninstall
        $UploadProcess = Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description $($App2upload.description) -Publisher $Publisher -InstallExperience $($App2upload.as) -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon        
    }
    catch{
        Write-Host "Error application $($App2upload.Name)" -ForegroundColor Red
        $_
    }
    # Sleep to prevent block from azure on a mass upload
    Start-sleep -s 15

    try{
        # Check dependency
        if($App2upload.Dependency){
            Write-Host "  Adding dependency $($App2upload.Dependency) to $($App2upload.Name)" -ForegroundColor Cyan
            $UploadedApp = Get-IntuneWin32App | where {$_.DisplayName -eq $App2upload.Name} | select name, id
            $DependendProgram = Get-IntuneWin32App | where {$_.DisplayName -eq $App2upload.Dependency} | select name, id
            if(!$DependendProgram){
                $DependendProgram_install = $Applications | where {$_.Name -eq $App2upload.Dependency}
                Write-Host "    dependent program $($DependendProgram.Name) is now being uploaded" -ForegroundColor Cyan
                Add-TheWin32App -App2upload $DependendProgram_install
                Start-Sleep -s 15
                $DependendProgram = Get-IntuneWin32App | where {$_.DisplayName -eq $App2upload.Dependency} | select name, id
            }
            $DependendProgram = Get-IntuneWin32App | where {$_.DisplayName -eq $App2upload.Dependency} | select name, id
            $Dependency = New-IntuneWin32AppDependency -id $DependendProgram.id -DependencyType AutoInstall
            $UploadProcess = Add-IntuneWin32AppDependency -id $UploadedApp.id -Dependency $Dependency
        }
    }catch{
        Write-Host "Error adding dependency for $($App2upload.Name)" -ForegroundColor Red
        $_
    }
}

function Select-TheWin32Apps{
    $global:Applications = Import-Csv -Path $CSV_Path -Delimiter ";" -Encoding UTF8
    $global:selectedApplications =  $Applications | Out-GridView -OutputMode Multiple -Title "Select Applications to create"
}

<# Prerequirements
Install-Module -Name IntuneWin32App -Force
Install-Module Microsoft.Graph -Force
#>
Import-Module -Name IntuneWin32App

# Initial Variables
$TenantPrefix = Read-Host "Tenant-Prefix (exp. scloudwork at scloudwork.onmicrosoft.com)"
$global:TenantID = "$TenantPrefix.onmicrosoft.com"
$global:Publisher = "scloud.work" # Change this with your organisations name
$Repo_Path = Read-Host "Software-Repo Path"
$CSV_Path = "$Repo_Path\Software-list.csv"

#Connect-AzureAD
$Session = Connect-MSIntuneGraph -TenantID $TenantID

#Select Applications
Select-TheWin32Apps

# process selected applications
foreach($Application in $selectedApplications){
    Add-TheWin32App -App2upload $Application
}
