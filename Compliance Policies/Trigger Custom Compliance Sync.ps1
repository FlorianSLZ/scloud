# Trigger a custom compliance sync
Start-Process -FilePath "C:\Program Files (x86)\Microsoft Intune Management Extension\Microsoft.Management.Services.IntuneWindowsAgent.exe" `
    -ArgumentList "intunemanagementextension://synccompliance"