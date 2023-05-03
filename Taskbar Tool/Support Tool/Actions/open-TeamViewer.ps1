$TVQS_url = "https://download.teamviewer.com/QS"
# Check if team Viewer is running
"C:\Program Files\TeamViewer\TeamViewer.exe"


if((Get-Process TeamViewer* -ea SilentlyContinue) -ne $Null){ 
	
}else{
	# Downlaod quicksupport
	$TVQS_local = "$($env:temp)\TVQS.exe"
	$webClient = New-Object System.Net.WebClient
	$webClient.DownloadFile($TVQS_url,$TVQS_local)
	Start-Process -FilePath $TVQS_local
}

