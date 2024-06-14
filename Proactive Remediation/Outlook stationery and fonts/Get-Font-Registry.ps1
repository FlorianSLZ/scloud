$ComposeFontComplex	=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ComposeFontComplex -join ",")
$ComposeFontSimple	=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ComposeFontSimple -join ",")
$MarkCommentsWith	=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").MarkCommentsWith -join ",")
$ReplyFontComplex	=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ReplyFontComplex -join ",")
$ReplyFontSimple	=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").ReplyFontSimple -join ",")
$TextFontComplex	=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").TextFontComplex -join ",")
$TextFontSimple		=	$($(Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings").TextFontSimple -join ",")


@"
# Font Settings Outlook
`$ComposeFontComplex = "$ComposeFontComplex"
`$ComposeFontSimple = "$ComposeFontSimple"
`$MarkCommentsWith = "$MarkCommentsWith"
`$ReplyFontComplex = "$ReplyFontComplex"
`$ReplyFontSimple = "$ReplyFontSimple"
`$TextFontComplex = "$TextFontComplex"
`$TextFontSimple = "$TextFontSimple"
"@ | Out-File -FilePath "$([Environment]::GetFolderPath("Desktop"))\FontSettingsOutlook.txt" -Encoding utf8