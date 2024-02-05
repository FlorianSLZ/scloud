function Get-TaskVerb { 
    param([int]$verbId) 
    try { 
        $t = [type]"CosmosKey.Util.MuiHelper" 
    } catch { 
        $def = [Text.StringBuilder]"" 
        [void]$def.AppendLine('[DllImport("user32.dll")]') 
        [void]$def.AppendLine('public static extern int LoadString(IntPtr h,uint id, System.Text.StringBuilder sb,int maxBuffer);') 
        [void]$def.AppendLine('[DllImport("kernel32.dll")]') 
        [void]$def.AppendLine('public static extern IntPtr LoadLibrary(string s);') 
        add-type -MemberDefinition $def.ToString() -name MuiHelper -namespace CosmosKey.Util             
    } 
    if($global:CosmosKey_Utils_MuiHelper_Shell32 -eq $null){         
        $global:CosmosKey_Utils_MuiHelper_Shell32 = [CosmosKey.Util.MuiHelper]::LoadLibrary("shell32.dll") 
    } 
    $maxVerbLength=255 
    $verbBuilder = new-object Text.StringBuilder "",$maxVerbLength 
    [void][CosmosKey.Util.MuiHelper]::LoadString($CosmosKey_Utils_MuiHelper_Shell32,$verbId,$verbBuilder,$maxVerbLength) 
    return $verbBuilder.ToString() 
} 

$apps = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items())
foreach ($app in $apps){
    $appname = $app.Name
    if ($appname -like "*store*"){
        $finalname = $app.Name
    }
}

if($finalname){
    Write-Host "Store is pinned to the Taskbar!"
    exit 1
}
else {
    Write-Host "Store not pinned. "
    exit 0
}