try{
    # Font Settings Outlook
    $ComposeFontComplex = ""
    $ComposeFontSimple = ""
    $ReplyFontComplex = ""
    $ReplyFontSimple = ""
    $TextFontComplex = ""
    $TextFontSimple = ""

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

}catch{
    Write-Error $_
}
