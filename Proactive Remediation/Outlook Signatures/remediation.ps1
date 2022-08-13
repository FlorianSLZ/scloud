try {
    $ODSignaturesPath = "$([Environment]::GetFolderPath("mydocuments"))\Signatures"
    # Create local Signatures folder
    New-Item -Path "$env:APPDATA\Microsoft\Signatures" -ItemType Directory -Force

    # Create AppData\Signatures folder in OneDrive for Business user folder
    New-Item -Path $ODSignaturesPath -ItemType Directory -Force

    # Copy local Signatures to OneDrive for Business
    Copy-Item -LiteralPath $env:APPDATA\Microsoft\Signatures -Destination $env:OneDriveCommercial\AppData -Recurse -Force

    # Copy OneDrive for Business Signatures to local folder
    Copy-Item -LiteralPath $ODSignaturesPath -Destination $env:APPDATA\Microsoft -Recurse -Force
    exit 0
}
catch {
    Write-Error $_
    exit 1
}