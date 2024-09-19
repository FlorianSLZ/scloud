<#
.SYNOPSIS
    Cleans the registry for failed Intune Win32 Apps

.DESCRIPTION
    This script identifies failed Intune-managed Win32 application installations on a device 
    and resets their status by removing related registry entries, forcing Microsoft Intune to retry the installations.

.NOTES
    Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
    Version: 1.1

    Changelog:
    - unknown date: 1.0 Initial version - Unknown source
    - 2024-08-15: 1.1 Transcript and Error handling
    
#>

Start-Transcript 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\WIN-PR-D-RetryFailedApps.log'
 
 
 
function Search-Registry {
   
    [CmdletBinding(DefaultParameterSetName = 'ByWildCard')]
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false, Position = 0)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
 
        [Parameter(Mandatory = $false, ParameterSetName = 'ByRegex')]
        [string]$RegexPattern,
 
        [Parameter(Mandatory = $false, ParameterSetName = 'ByWildCard')]
        [string]$Pattern,
 
        [Parameter(Mandatory = $false)]
        [ValidateSet('HKEY_CLASSES_ROOT', 'HKEY_CURRENT_CONFIG', 'HKEY_CURRENT_USER', 'HKEY_DYN_DATA', 'HKEY_LOCAL_MACHINE',
            'HKEY_PERFORMANCE_DATA', 'HKEY_USERS', 'HKCR', 'HKCC', 'HKCU', 'HKDD', 'HKLM', 'HKPD', 'HKU')]
        [string]$Hive,
 
        [string]$KeyPath,
        [int32] $MaximumResults = [int32]::MaxValue,
        [switch]$SearchKeyName,
        [switch]$SearchPropertyName,
        [switch]$SearchPropertyValue,
        [switch]$Recurse
    )
    Begin {
        [bool]$isPipeLine = $MyInvocation.ExpectingInput
 
        # sanitize given parameters
        if ([string]::IsNullOrWhiteSpace($ComputerName) -or $ComputerName -eq '.') { $ComputerName = $env:COMPUTERNAME }
 
        # parse the give KeyPath
        if ($KeyPath -match '^(HK(?:CR|CU|LM|U|PD|CC|DD)|HKEY_[A-Z_]+)[:\\]?') {
            $Hive = $matches[1]
            # remove HKLM, HKEY_CURRENT_USER etc. from the path
            $KeyPath = $KeyPath.Split("\", 2)[1]
        }
        switch ($Hive) {
            { @('HKCC', 'HKEY_CURRENT_CONFIG') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::CurrentConfig; break }
            { @('HKCR', 'HKEY_CLASSES_ROOT') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::ClassesRoot; break }
            { @('HKCU', 'HKEY_CURRENT_USER') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::CurrentUser; break }
            { @('HKDD', 'HKEY_DYN_DATA') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::DynData; break }
            { @('HKLM', 'HKEY_LOCAL_MACHINE') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::LocalMachine; break }
            { @('HKPD', 'HKEY_PERFORMANCE_DATA') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::PerformanceData; break }
            { @('HKU', 'HKEY_USERS') -contains $_ } { $objHive = [Microsoft.Win32.RegistryHive]::Users; break }
        }
 
        # critical: Hive could not be determined
        if (!$objHive) {
            Throw "Parameter 'Hive' not specified or could not be parsed from the 'KeyPath' parameter."
        }
 
        # critical: no search criteria given
        if (-not ($SearchKeyName -or $SearchPropertyName -or $SearchPropertyValue)) {
            Throw "You must specify at least one of these parameters: 'SearchKeyName', 'SearchPropertyName' or 'SearchPropertyValue'"
        }
 
        # no patterns given will only work for SearchPropertyName and SearchPropertyValue
        if ([string]::IsNullOrEmpty($RegexPattern) -and [string]::IsNullOrEmpty($Pattern)) {
            if ($SearchKeyName) {
                Write-Warning "Both parameters 'RegexPattern' and 'Pattern' are emtpy strings. Searching for KeyNames will not yield results."
            }
        }
 
        # create two variables for output purposes
        switch ($objHive.ToString()) {
            'CurrentConfig' { $hiveShort = 'HKCC'; $hiveName = 'HKEY_CURRENT_CONFIG' }
            'ClassesRoot' { $hiveShort = 'HKCR'; $hiveName = 'HKEY_CLASSES_ROOT' }
            'CurrentUser' { $hiveShort = 'HKCU'; $hiveName = 'HKEY_CURRENT_USER' }
            'DynData' { $hiveShort = 'HKDD'; $hiveName = 'HKEY_DYN_DATA' }
            'LocalMachine' { $hiveShort = 'HKLM'; $hiveName = 'HKEY_LOCAL_MACHINE' }
            'PerformanceData' { $hiveShort = 'HKPD'; $hiveName = 'HKEY_PERFORMANCE_DATA' }
            'Users' { $hiveShort = 'HKU' ; $hiveName = 'HKEY_USERS' }
        }
 
        if ($MaximumResults -le 0) { $MaximumResults = [int32]::MaxValue }
        $script:resultCount = 0
        [bool]$useRegEx = ($PSCmdlet.ParameterSetName -eq 'ByRegex')
 
        # -------------------------------------------------------------------------------------
        # Nested helper function to (recursively) search the registry
        # -------------------------------------------------------------------------------------
        function _RegSearch([Microsoft.Win32.RegistryKey]$objRootKey, [string]$regPath, [string]$computer) {
            try {
                if ([string]::IsNullOrWhiteSpace($regPath)) {
                    $objSubKey = $objRootKey
                }
                else {
                    $regPath = $regPath.TrimStart("\")
                    $objSubKey = $objRootKey.OpenSubKey($regPath, $false)    # $false --> ReadOnly
                }
            }
            catch {
                Write-Warning ("Error opening $($objRootKey.Name)\$regPath" + "`r`n         " + $_.Exception.Message)
                return
            }
            $subKeys = $objSubKey.GetSubKeyNames()
 
            # Search for Keyname
            if ($SearchKeyName) {
                foreach ($keyName in $subKeys) {
                    if ($script:resultCount -lt $MaximumResults) {
                        if ($useRegEx) { $isMatch = ($keyName -match $RegexPattern) }
                        else { $isMatch = ($keyName -like $Pattern) }
                        if ($isMatch) {
                            # for PowerShell < 3.0 use: New-Object -TypeName PSObject -Property @{ ... }
                            [PSCustomObject]@{
                                'ComputerName'     = $computer
                                'Hive'             = $objHive.ToString()
                                'HiveName'         = $hiveName
                                'HiveShortName'    = $hiveShort
                                'Path'             = $objSubKey.Name
                                'SubKey'           = "$regPath\$keyName".TrimStart("\")
                                'ItemType'         = 'RegistryKey'
                                'DataType'         = $null
                                'ValueKind'        = $null
                                'PropertyName'     = $null
                                'PropertyValue'    = $null
                                'PropertyValueRaw' = $null
                            }
                            $script:resultCount++
                        }
                    }
                }
            }
 
            # search for PropertyName and/or PropertyValue
            if ($SearchPropertyName -or $SearchPropertyValue) {
                foreach ($name in $objSubKey.GetValueNames()) {
                    if ($script:resultCount -lt $MaximumResults) {
                        $data = $objSubKey.GetValue($name)
                        $raw = $objSubKey.GetValue($name, '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
 
                        if ($SearchPropertyName) {
                            if ($useRegEx) { $isMatch = ($name -match $RegexPattern) }
                            else { $isMatch = ($name -like $Pattern) }
 
                        }
                        else {
                            if ($useRegEx) { $isMatch = ($data -match $RegexPattern -or $raw -match $RegexPattern) }
                            else { $isMatch = ($data -like $Pattern -or $raw -like $Pattern) }
                        }
 
                        if ($isMatch) {
                            $kind = $objSubKey.GetValueKind($name).ToString()
                            switch ($kind) {
                                'Binary' { $dataType = 'REG_BINARY'; break }
                                'DWord' { $dataType = 'REG_DWORD'; break }
                                'ExpandString' { $dataType = 'REG_EXPAND_SZ'; break }
                                'MultiString' { $dataType = 'REG_MULTI_SZ'; break }
                                'QWord' { $dataType = 'REG_QWORD'; break }
                                'String' { $dataType = 'REG_SZ'; break }
                                default { $dataType = 'REG_NONE'; break }
                            }
                            # for PowerShell < 3.0 use: New-Object -TypeName PSObject -Property @{ ... }
                            [PSCustomObject]@{
                                'ComputerName'     = $computer
                                'Hive'             = $objHive.ToString()
                                'HiveName'         = $hiveName
                                'HiveShortName'    = $hiveShort
                                'Path'             = $objSubKey.Name
                                'SubKey'           = $regPath.TrimStart("\")
                                'ItemType'         = 'RegistryProperty'
                                'DataType'         = $dataType
                                'ValueKind'        = $kind
                                'PropertyName'     = if ([string]::IsNullOrEmpty($name)) { '(Default)' } else { $name }
                                'PropertyValue'    = $data
                                'PropertyValueRaw' = $raw
                            }
                            $script:resultCount++
                        }
                    }
                }
            }
 
            # recurse through all subkeys
            if ($Recurse) {
                foreach ($keyName in $subKeys) {
                    if ($script:resultCount -lt $MaximumResults) {
                        $newPath = "$regPath\$keyName"
                        _RegSearch $objRootKey $newPath $computer
                    }
                }
            }
 
            # close opened subkey
            if (($objSubKey) -and $objSubKey.Name -ne $objRootKey.Name) { $objSubKey.Close() }
        }
    }
    Process {
        if ($isPipeLine) { $ComputerName = @($_) }
        $ComputerName | ForEach-Object {
            Write-Verbose "Searching the registry on computer '$ComputerName'.."
            try {
                $rootKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($objHive, $_)
                _RegSearch $rootKey $KeyPath $_
            }
            catch {
                Write-Error "$($_.Exception.Message)"
            }
            finally {
                if ($rootKey) { $rootKey.Close() }
            }
        }
        Write-Verbose "All Done searching the registry. Found $($script:resultCount) results."
    }
}
#### END FUNCTIONS ####
 
#### SCRIPT ENTRY POINT ####
 
# Grab the enforcement states for all apps
$States = Search-Registry -Hive HKLM  -KeyPath 'SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps' -SearchPropertyName -Pattern EnforcementStateMessage -Recurse
 
# Determine if any are failures. If we find any, remove the reg key(s)
Foreach ($State in $States) {
    if (($State -notmatch '"ErrorCode":0') -and ($State -notmatch '"ErrorCode":3010')) {
       
        Write-Host "We found failure(s), let's fix!"
        $State
 
        #Get the reg keys into formats we can use.
        $ShortPath = Split-Path -path $State.Subkey -Parent
        $NoVer = ("$ShortPath").Substring(0, "$ShortPath".IndexOf("_"))
        $ID = Split-Path -path $NoVer -Leaf
        $UserPath = Split-Path -path $NoVer -Parent
        $User = Split-Path -path $UserPath -Leaf
        $UserGRS = ($UserPath + "\GRS")
        $Regpath = ("HKLM:\" + $ShortPath)
       
        # Remove the run history
        Write-Host "$ID failed for $User"
        if (Test-Path -Path $Regpath) {
            Write-Host "Validated key path, deleting it"
            try {
                Write-Host "Removing $Regpath"
                Remove-Item -Path $Regpath -Recurse -Force -ErrorAction SilentlyContinue
            }
            Catch {
                Write-error $_
            }
        }else{
            Write-Host "Registry key $regPath could not be validated. Something is wrong!"
        }
       
        # Find and Remove the GRS entries
        Write-Host "Looking for GRS entries for the failed app"
        $GRSResult = Search-Registry -Hive HKLM  -KeyPath $UserGRS -SearchPropertyName -Pattern $ID -Recurse
        If ($GRSResult) {
            $GRSPath = ("HKLM:\" + $GRSResult.Subkey)
            if (test-path -Path $GRSPath) {            
                try {
                    Write-Host "Removing $GRSPath"
                    Remove-Item -Path $GRSPath -Recurse -Force -ErrorAction SilentlyContinue
                }
                Catch {
                    Write-error $_
                }else{
                    Write-Host "Registry key $GRSPath could not be validated. Something is wrong!"
                }
            }
        }
    }
}
 
# If we found anything to delete restart IME
$Count = $GRSPath.Count + $RegPath.Count
If ($Count -gt 0) {
    Write-Host "$Count keys removed, restarting IME"
    Get-Service -DisplayName "Microsoft Intune Management Extension" | Restart-Service -Force -PassThru
    Clear-Variable -Name Count
    Clear-Variable -Name GRSPath
    Clear-Variable -Name Regpath
 
}
else {
    Write-Host "No failures detected. Not restarting IME."
 
}
 
Stop-Transcript
 