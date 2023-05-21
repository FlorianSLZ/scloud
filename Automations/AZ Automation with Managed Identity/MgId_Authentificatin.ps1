try {
    # Logging in to Azure.
    Connect-AzAccount -Identity

    # Get token and connect to MgGraph
    Connect-MgGraph -AccessToken ((Get-AzAccessToken -ResourceTypeName MSGraph).token)
} catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

