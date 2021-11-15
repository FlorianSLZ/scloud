<#
Install-Module -Name IntuneWin32App -Force
Install-Module Microsoft.Graph -Force
#>
Import-Module -Name IntuneWin32App

# Initial Variabeln
$TenantPrefix = Read-Host "Tenant-Prefix (z.B. 4netag bei 4netag.onmicrosoft.com)"
$TenantName = "$TenantPrefix.onmicrosoft.com"
$Publisher = "4net AG"
$Repo_Path = Read-Host "Software-Repo Pfad"
$CSV_Path = "$Repo_Path\Software-Liste.csv"

#Connect-AzureAD
Connect-MSIntuneGraph -TenantName $TenantName

#Select Appliacations
$Applications = Import-Csv -Path $CSV_Path -Delimiter ";" -Encoding UTF8
$selectedApplications =  $Applications | Out-GridView -OutputMode Multiple -Title "Select Applications to create"


foreach($Application in $selectedApplications){
    Write-Host "(i) Verarbeitung der Applikation $($Application.Name)" -ForegroundColor Cyan
    try{
        
        # Graph Connect 
        Connect-MSIntuneGraph -TenantName $TenantName

        # .intunewin für Upload erstellen
        $IntuneWinFile = "$Repo_Path\$($Application.Name)\install.intunewin"

        # Displayname abfüllen
        $DisplayName = "$($Application.Name)"

        # Erkennungs Regel erstellen
        Write-Host "Erkennungs Regel erstellen"
        $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$Repo_Path\$($Application.Name)\check.ps1" -EnforceSignatureCheck $false -RunAs32Bit $false

        # Mindest Anforderungen an Applikation
        $RequirementRule = New-IntuneWin32AppRequirementRule -Architecture x64 -MinimumSupportedOperatingSystem 2004

        # Bild für Company Portal
        $ImageFile = "$Repo_Path\$($Application.Name)\$($Application.Name).png"
        $Icon = New-IntuneWin32AppIcon -FilePath $ImageFile

        # Upload 
        $InstallCommandLine = $Application.install
        $UninstallCommandLine = $Application.uninstall
        Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description $($Application.Beschreibung) -Publisher $Publisher -InstallExperience $($Application.as) -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon        
        
    }
    catch{
        Write-Host "Fehler Applikation $($Application.Name)" -ForegroundColor Red
        $_
    }
    # Sleep um bei einer massenverarbeitung nciht geblockt zu werden
    Start-sleep -s 15

}

