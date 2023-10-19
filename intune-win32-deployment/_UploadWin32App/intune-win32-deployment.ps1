$ErrorActionpreference = "stop"

<# Prerequirements
Install-Module -Name IntuneWin32App -RequiredVersion 1.4.1 -Force
Install-Module Microsoft.Graph.Intune -Force
#>

# Functions
function Add-TheWin32App([Array] $App2upload){

    try{

        Write-Host "Reading all apps from Intune"  -ForegroundColor Gray
        Connect-MSIntuneGraph -TenantID $Global:AccessTokenTenantID -Refresh | Out-Null
        $IntuneApps_all = Get-IntuneWin32App

        Write-Host "Processing App: $($App2upload.Name) " -ForegroundColor Cyan
        $AppFolder = Get-Item -Path "$Repo_Path\$($App2upload.Name)"

        Connect-MSIntuneGraph -TenantID $Global:AccessTokenTenantID -Refresh | Out-Null

        # Check if app already existis in Intune
        if($App2upload.Name -in $IntuneApps_all.DisplayName){
            Write-Host "   App $($App2upload.Name) already exists in Intune" -ForegroundColor Yellow
            Write-Host "   Skipping app $($App2upload.Name)" -ForegroundColor Yellow
            break
        }

        # clean up old Intune file
        New-Item -Path "$Repo_Path\_intunewin\" -ItemType Directory -Force | Out-Null
        $FileName = "$Repo_Path\_intunewin\$($App2upload.Name).intunewin"
        if (Test-Path $FileName) { Remove-Item $FileName }

        # Create intunewin file
        $IntuneWinFile = "$Repo_Path\$($App2upload.Name)\install.intunewin"
        if(Test-Path $IntuneWinFile){
            Write-Host "   Using existing intunewin file" -ForegroundColor Cyan
            $IntuneWinFile = "$Repo_Path\$($App2upload.Name)\install.intunewin"
        }else{
            Write-Host "   Creating new intunewin file" -ForegroundColor Cyan
            $IntuneWinNEW = New-IntuneWin32AppPackage -SourceFolder $($AppFolder.FullName) -SetupFile "install.ps1" -OutputFolder "$Repo_Path\_intunewin" -Force
            Rename-Item -Path $IntuneWinNEW.Path -NewName "$($App2upload.Name).intunewin"
        
            $IntuneWinFile = (Get-ChildItem "$Repo_Path\_intunewin" -Filter "$($App2upload.Name).intunewin").FullName
        }


        # Create requirement rule for all platforms and Windows 10 2004
        $RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "x64" -MinimumSupportedWindowsRelease "W10_2004"

        # Create PowerShell script detection rule
        $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$Repo_Path\$($App2upload.Name)\check.ps1" -EnforceSignatureCheck $false -RunAs32Bit $false
        
        # install command
        $InstallCommandLine = $App2upload.install
        $UninstallCommandLine = $App2upload.uninstall

        # check for png or jpg
        $Icon_path = (Get-ChildItem "$($AppFolder.FullName)\*" -Include "*.jpg", "*.png" | Select-Object -First 1).FullName
        if(!$Icon_path){
            $Icon_path = "$env:temp\app.png"
            $img_url = "https://raw.githubusercontent.com/FlorianSLZ/scloud/main/img/app.png"
            Invoke-WebRequest -Uri $img_url -OutFile $Icon_path
        }
        $Icon = New-IntuneWin32AppIcon -FilePath $Icon_path


        $AppUpload = Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $App2upload.Name -Description $App2upload.Description -AppVersion $App2upload.Version -Publisher $Publisher -InstallExperience $($App2upload.as) -Icon $Icon -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine


        Start-sleep -s 3
    }catch{
        Write-Host "Error application $($App2upload.Name)" -ForegroundColor Red
        $_
    } 

    try{
        # Check dependency
        if($App2upload.Dependency){
            Write-Host "  Processing dependency $($App2upload.Dependency) to $($App2upload.Name)" -ForegroundColor Cyan
            $UploadedApp = Get-IntuneWin32App | Where-Object {$_.DisplayName -eq $App2upload.Name} | Select-Object name, id
            $DependendProgram = Get-IntuneWin32App | Where-Object {$_.DisplayName -eq $App2upload.Dependency} | Select-Object name, id
            if(!$DependendProgram){
                $DependendProgram_install = $Applications | Where-Object {$_.Name -eq $App2upload.Dependency}
                Write-Host "    dependent program $($App2upload.Dependency) is now being uploaded" -ForegroundColor Cyan
                Add-TheWin32App -App2upload $DependendProgram_install
                Start-Sleep -s 5
                $DependendProgram = Get-IntuneWin32App | Where-Object {$_.DisplayName -eq $App2upload.Dependency} | Select-Object name, id
            }
            
            $Dependency = New-IntuneWin32AppDependency -id $DependendProgram.id -DependencyType AutoInstall
            $UploadProcess = Add-IntuneWin32AppDependency -id $UploadedApp.id -Dependency $Dependency
            Write-Host "  Added dependency $($App2upload.Dependency) to $($App2upload.Name)" -ForegroundColor Cyan
        }
    }catch{
        Write-Host "Error adding dependency for $($App2upload.Name)" -ForegroundColor Red
        $_
    }
}


function Select-TheWin32Apps{
    $global:Applications = Import-Csv -Path $CSV_Path -Delimiter ";" -Encoding UTF8
    $global:selectedApplications =  $Applications | Out-GridView -OutputMode Multiple -Title "Select Applications to create"
    Write-Verbose $selectedApplications
}

Import-Module -Name IntuneWin32App

# Initial Variables
$TenantPrefix = Read-Host "Tenant-Prefix (exp. scloudwork at scloudwork.onmicrosoft.com)"
$global:TenantID = "$TenantPrefix.onmicrosoft.com"
$global:Publisher = "scloud.work" # Change this with your organisations name
$Repo_Path = Read-Host "Software-Repo Path"
$CSV_Path = "$Repo_Path\Software-list.csv"

#Connect-AzureAD
$Session = Connect-MSIntuneGraph -TenantID $TenantID
Write-Verbose $Session

#Select Applications
Select-TheWin32Apps

# process selected applications
foreach($Application in $selectedApplications){
    Add-TheWin32App -App2upload $Application
}
