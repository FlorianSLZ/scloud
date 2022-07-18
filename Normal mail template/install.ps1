$PackageName = "NormalEmail-template"
$Version = "1"

# Font Settings/Values Outlook
$ComposeFontComplex = ""
$ComposeFontSimple = ""
$MarkCommentsWith = ""
$ReplyFontComplex = ""
$ReplyFontSimple = ""
$TextFontComplex = ""
$TextFontSimple = ""
#######################################################################################################################################
#   Get the RegValues
#######################################################################################################################################
<# 
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ComposeFontComplex -join ",")
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ComposeFontSimple -join ",")
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").MarkCommentsWith -join ",")
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ReplyFontComplex -join ",").
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ReplyFontSimple -join ",")
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").TextFontComplex -join ",")
$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").TextFontSimple -join ",")
#>


# Transcript for local log
$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-install.log" -Force
$ErrorActionPreference = "Stop"

#######################################################################################################################################
#   Font Settings
#######################################################################################################################################
$Path = "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings" 
if(!(Test-Path $Path)){New-Item -Path $Path -Force}

if($ComposeFontComplex){Set-ItemProperty -Path $Path -Name "ComposeFontComplex" -Value ([byte[]]$($ComposeFontComplex.Split(',') | % { "$_"})) -Type "Binary"}
if($ComposeFontSimple){Set-ItemProperty -Path $Path -Name "ComposeFontSimple" -Value ([byte[]]$($ComposeFontSimple.Split(',') | % { "$_"})) -Type "Binary"}
if($MarkCommentsWith){Set-ItemProperty -Path $Path -Name "MarkCommentsWith" -Value ([byte[]]$($MarkCommentsWith.Split(',') | % { "$_"})) -Type "Binary"}
if($ReplyFontComplex){Set-ItemProperty -Path $Path -Name "ReplyFontComplex" -Value ([byte[]]$($ReplyFontComplex.Split(',') | % { "$_"})) -Type "Binary"}
if($ReplyFontSimple){Set-ItemProperty -Path $Path -Name "ReplyFontSimple" -Value ([byte[]]$($ReplyFontSimple.Split(',') | % { "$_"})) -Type "Binary"}
if($TextFontComplex){Set-ItemProperty -Path $Path -Name "TextFontComplex" -Value ([byte[]]$($TextFontComplex.Split(',') | % { "$_"})) -Type "Binary"}
if($TextFontSimple){Set-ItemProperty -Path $Path -Name "TextFontSimple" -Value ([byte[]]$($TextFontSimple.Split(',') | % { "$_"})) -Type "Binary"}


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
    New-Item -Path "$Path_4Log\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
