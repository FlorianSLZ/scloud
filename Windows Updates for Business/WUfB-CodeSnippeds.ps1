#########################################################
#   Required Module
#########################################################
Install-Module Microsoft.Graph


#########################################################
#   Connect to Graph
#########################################################
Select-MgProfile -Name "beta"
Connect-MgGraph -Scopes "WindowsUpdates.ReadWrite.All","User.Read.All","Device.Read.All","Group.Read.All"

#########################################################
#   Get/Check Device rediness status
#########################################################
$DeviceID = (Get-MgDevice | Out-GridView -Mode Single).DeviceId
Get-MgWuUpdatableAsset  -UpdatableAssetId $DeviceID

#########################################################
#   Enroll Device to WUfB
#########################################################
Invoke-MgEnrollWindowsUpdatesUpdatableAsset -UpdateCategory "feature"  -Assets @(@{
                "@odata.type"= "#microsoft.graph.windowsUpdates.azureADDevice";
                "id" = $DeviceID
            })

# check enrolment
Get-MgWuUpdatableAsset -UpdatableAssetId $DeviceID

#########################################################
#   List Updates
#########################################################
# Feature Updates
Get-MgWindowsUpdatesCatalogEntry -Filter "isof('microsoft.graph.windowsUpdates.featureUpdateCatalogEntry')"

# Quality Updates
Get-MgWindowsUpdatesCatalogEntry -Filter "isof('microsoft.graph.windowsUpdates.qualityUpdateCatalogEntry')"

# Deployments
Get-MgWindowsUpdatesDeployment


##################
## Create Group ##

#Create a new Updatable Asset Group
$updatableAssetGroup = New-MgWindowsUpdatesUpdatableAsset -BodyParameter @{
    "@odata.type" = "#microsoft.graph.windowsUpdates.updatableAssetGroup"
}

#Get Developers Group
$developerGroup = Get-MgGroup -Filter "DisplayName eq 'Development'"


#Add each member of the Developers group to the Updatable Asset Group
foreach ($groupMember in (Get-MgGroupMember -GroupId $developerGroup.Id))
{
    Add-MgWindowsUpdatesUpdatableAssetMember -UpdatableAssetId $updatableAssetGroup -BodyParameter @{
	    Assets = @(
		    @{
			    "@odata.type" = "#microsoft.graph.windowsUpdates.azureADDevice"
			    Id = $groupMember.Id
		    }
	    )
    }
}




##################
## Deploy an FU ##

## Create deployment for Win 10 20H2 to start Jan 1, 2023 ##
$fuDeployment = New-MgWindowsUpdatesDeployment -BodyParameter  @{
	"@odata.type" = "microsoft.graph.windowsUpdates.deployment"
	Content = @{
		"@odata.type" = "microsoft.graph.windowsUpdates.featureUpdateReference"
		Version = "20H2"
	}
	Settings = @{
		"@odata.type" = "microsoft.graph.windowsUpdates.windowsDeploymentSettings"
		Rollout = @{
			startDateTime = [DateTime]"2022-01-01T00:00:00Z"
		}
		Monitoring = @{
			MonitoringRules = @(
				@{
					"@odata.type" = "microsoft.graph.windowsUpdates.monitoringRule"
					Signal = "rollback"
					Threshold = 5
					Action = "pauseDeployment"
				}
			)
		}
	}
}

# Add the new Updatable Asset Group as the Audient to the Deployment
Update-MgWindowsUpdatesDeploymentAudience -DeploymentID $fuDeployment.Id -AddMembers @(
        @{
            "id" = $updatableAssetGroup; 
            "@odata.type" = "Microsoft.graph.WindowsUpdates.updatableAssetGroup"
        }
    ) 

# Verify Deployment Exists
Get-MgWindowsUpdatesDeployment -DeploymentId $fuDeployment.Id



####################
## Slow your Roll ##

# Add gradual rollout to previous FU deployment
Update-MgWindowsUpdatesDeployment -DeploymentId $fuDeployment.Id -Settings @{
		"@odata.type" = "microsoft.graph.windowsUpdates.windowsDeploymentSettings"
		Rollout = @{
			    devicesPerOffer = 100
                durationBetweenOffers = "P7D"
		    }
        }

# Pause FU deployment
Update-MgWindowsUpdatesDeployment -DeploymentId $fuDeployment.Id -State @{
		"@odata.type" = "microsoft.graph.windowsUpdates.deploymentState"
		requestedValue = "paused"
        }


###################
## Expedite a CU ##

# View list of expeditable updates
Get-MgWindowsUpdatesCatalogEntry -Filter "microsoft.graph.windowsUpdates.qualityUpdateCatalogEntry/isExpeditable eq true"

# Create the Expedite deployment with 4 day enforcement
$cuDeployment = New-MgWindowsUpdatesDeployment -Content @{
    "@odata.type" = "microsoft.graph.windowsUpdates.expeditedQualityUpdatereference";
     "releaseDate" = "2022-05-03"

     } `
     -Settings @{
		"@odata.type" = "microsoft.graph.windowsUpdates.windowsDeploymentSettings"
		"UserExperience" = @{
			"daysUntilForcedReboot" = "4"
		    }
    }


# Add the new Updatable Asset Group as the Audient to the Deployment
Update-MgWindowsUpdatesDeploymentAudience -DeploymentID $cuDeployment.Id -AddMembers @(
        @{
            "id" = $updatableAssetGroup; 
            "@odata.type" = "Microsoft.graph.WindowsUpdates.updatableAssetGroup"
        }
    ) 

# Verify the deployment
Get-MgWindowsUpdatesDeployment -DeploymentId $cuDeployment.Id

#Remove Deployment
Remove-MgWindowsUpdatesDeployment -DeploymentId $cuDeployment.Id



# Clean Up our Mess
Remove-MgWindowsUpdatesUpdatableAsset -UpdatableAssetId $updatableAssetGroup
Remove-MgWindowsUpdatesDeployment -DeploymentId $fuDeployment.Id
Invoke-MgUnenrollWindowsUpdatesUpdatableAsset -UpdateCategory "feature"  -Assets @(@{
                "@odata.type"= "#microsoft.graph.windowsUpdates.azureADDevice";
                "id" = $DeviceID
            })