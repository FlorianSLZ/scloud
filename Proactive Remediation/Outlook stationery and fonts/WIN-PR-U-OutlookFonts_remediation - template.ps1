try{
    # Font Settings Outlook
    $ComposeFontComplex    = ""
    $ComposeFontSimple     = ""
    $MarkCommentsWith      = ""
    $ReplyFontComplex      = ""
    $ReplyFontSimple       = ""
    $TextFontComplex       = ""
    $TextFontSimple        = ""

    $Path = "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings" 
    if(!(Test-Path $Path)){New-Item -Path $Path -Force}

    if($ComposeFontComplex){Set-ItemProperty -Path $Path -Name "ComposeFontComplex" -Value ([byte[]]$($ComposeFontComplex.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}
    if($ComposeFontSimple){Set-ItemProperty -Path $Path -Name "ComposeFontSimple" -Value ([byte[]]$($ComposeFontSimple.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}
    if($MarkCommentsWith){Set-ItemProperty -Path $Path -Name "MarkCommentsWith" -Value ([byte[]]$($MarkCommentsWith.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}
    if($ReplyFontComplex){Set-ItemProperty -Path $Path -Name "ReplyFontComplex" -Value ([byte[]]$($ReplyFontComplex.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}
    if($ReplyFontSimple){Set-ItemProperty -Path $Path -Name "ReplyFontSimple" -Value ([byte[]]$($ReplyFontSimple.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}
    if($TextFontComplex){Set-ItemProperty -Path $Path -Name "TextFontComplex" -Value ([byte[]]$($TextFontComplex.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}
    if($TextFontSimple){Set-ItemProperty -Path $Path -Name "TextFontSimple" -Value ([byte[]]$($TextFontSimple.Split(',') | ForEach-Object { "$_"})) -Type "Binary"}

}catch{
    Write-Error $_
}
