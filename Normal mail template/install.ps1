$PackageName = "NormalEmail-template"
$Version = "1"

# Font Settings Outlook
$ComposeFontComplex = ""
$ComposeFontSimple = ""
$MarkCommentsWith = ""
$ReplyFontComplex = ""
$ReplyFontSimple = ""
$TextFontComplex = ""
$TextFontSimple = ""

# Transcript for local log
$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-$env:USERNAME-install.log" -Force
$ErrorActionPreference = "Stop"

#######################################################################################################################################
#   Font Settings
#######################################################################################################################################
$Path = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\MailSettings" 
if(!(Test-Path $Path)){New-Item -Path $Path -Force}

if($ComposeFontComplex){Set-ItemProperty -Path $Path -Name "ComposeFontComplex" -Value $ComposeFontComplex -Type "Binary"}
if($ComposeFontSimple){Set-ItemProperty -Path $Path -Name "ComposeFontSimple" -Value $ComposeFontSimple -Type "Binary"}
if($MarkCommentsWith){Set-ItemProperty -Path $Path -Name "MarkCommentsWith" -Value $MarkCommentsWith -Type "Binary"}
if($ReplyFontComplex){Set-ItemProperty -Path $Path -Name "ReplyFontComplex" -Value $ReplyFontComplex -Type "Binary"}
if($ReplyFontSimple){Set-ItemProperty -Path $Path -Name "ReplyFontSimple" -Value $ReplyFontSimple -Type "Binary"}
if($TextFontComplex){Set-ItemProperty -Path $Path -Name "TextFontComplex" -Value $TextFontComplex -Type "Binary"}
if($TextFontSimple){Set-ItemProperty -Path $Path -Name "TextFontSimple" -Value $TextFontSimple -Type "Binary"}


#######################################################################################################################################
#   NormailEmail.dotm
#######################################################################################################################################

$NormalEmail_File = "$env:APPDATA\Microsoft\Templates\NormalEmail.dotm"

try{
    New-Item -Path "$env:APPDATA\Microsoft\Templates" -ItemType "Directory" -Force
    try{
        if(Test-Path $NormalEmail_File){Remove-Item -Path $NormalEmail_File -Force}
        Copy-Item 'NormalEmail.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force
    }catch{
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show('Your Outlook needs an Update with a restart. Please press OK to restart Outlook')
        Get-Process Outlook | Stop-Process -Force
        Start-Sleep 5
        if(Test-Path $NormalEmail_File){Remove-Item -Path $NormalEmail_File -Force}
        Copy-Item 'NormalEmail.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force
        Start-Process Outlook
    }
    # Validation file
    New-Item -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
