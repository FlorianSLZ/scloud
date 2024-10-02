try {
    # Font Settings Outlook
    $ComposeFontComplex    = ""
    $ComposeFontSimple     = ""
    $MarkCommentsWith      = ""
    $ReplyFontComplex      = ""
    $ReplyFontSimple       = ""
    $TextFontComplex       = ""
    $TextFontSimple        = ""
    
    #####################################################################################
    # Functions START
    #####################################################################################

    # Convert Expected Byte Strings to Byte Arrays
    function Convert-StringToByteArray {
        param (
            [string]$String
        )
        return ($String -split ',' | ForEach-Object { [byte]$_ })
    }

    # Function to Compare Two Byte Arrays
    function Compare-ByteArrays {
        param (
            [byte[]]$Array1,
            [byte[]]$Array2
        )

        if ($Array1.Length -ne $Array2.Length) {
            return $false
        }

        for ($i = 0; $i -lt $Array1.Length; $i++) {
            if ($Array1[$i] -ne $Array2[$i]) {
                return $false
            }
        }
        return $true
    }

    #####################################################################################
    # Functions END
    #####################################################################################


    # Convert Expected Byte Strings to Byte Arrays
    $expectedComposeFontComplex = Convert-StringToByteArray -String $ComposeFontComplex
    $expectedComposeFontSimple  = Convert-StringToByteArray -String $ComposeFontSimple
    $expectedMarkCommentsWith   = Convert-StringToByteArray -String $MarkCommentsWith
    $expectedReplyFontComplex   = Convert-StringToByteArray -String $ReplyFontComplex
    $expectedReplyFontSimple    = Convert-StringToByteArray -String $ReplyFontSimple
    $expectedTextFontComplex    = Convert-StringToByteArray -String $TextFontComplex
    $expectedTextFontSimple     = Convert-StringToByteArray -String $TextFontSimple

    # Define Registry Path
    $Path = "HKCU:\Software\Microsoft\Office\16.0\Common\MailSettings"

    if (!(Test-Path $Path)) {
        Write-Output "Registry path '$Path' does not exist. Font Settings Outlook are NOT set correctly."
        exit 1
    }

    # Retrieve Actual Registry Values
    $actualComposeFontComplex = Get-ItemPropertyValue -Path $Path -Name ComposeFontComplex
    $actualComposeFontSimple  = Get-ItemPropertyValue -Path $Path -Name ComposeFontSimple
    $actualMarkCommentsWith   = Get-ItemPropertyValue -Path $Path -Name MarkCommentsWith
    $actualReplyFontComplex   = Get-ItemPropertyValue -Path $Path -Name ReplyFontComplex
    $actualReplyFontSimple    = Get-ItemPropertyValue -Path $Path -Name ReplyFontSimple
    $actualTextFontComplex    = Get-ItemPropertyValue -Path $Path -Name TextFontComplex
    $actualTextFontSimple     = Get-ItemPropertyValue -Path $Path -Name TextFontSimple

    # Perform Comparisons
    $isComposeFontComplexMatch = Compare-ByteArrays -Array1 $actualComposeFontComplex -Array2 $expectedComposeFontComplex
    $isComposeFontSimpleMatch  = Compare-ByteArrays -Array1 $actualComposeFontSimple  -Array2 $expectedComposeFontSimple
    $isMarkCommentsWithMatch   = Compare-ByteArrays -Array1 $actualMarkCommentsWith   -Array2 $expectedMarkCommentsWith
    $isReplyFontComplexMatch   = Compare-ByteArrays -Array1 $actualReplyFontComplex   -Array2 $expectedReplyFontComplex
    $isReplyFontSimpleMatch    = Compare-ByteArrays -Array1 $actualReplyFontSimple    -Array2 $expectedReplyFontSimple
    $isTextFontComplexMatch    = Compare-ByteArrays -Array1 $actualTextFontComplex    -Array2 $expectedTextFontComplex
    $isTextFontSimpleMatch     = Compare-ByteArrays -Array1 $actualTextFontSimple     -Array2 $expectedTextFontSimple

    # Debugging Output (Optional: Remove in Production)
    Write-Output "ComposeFontComplex Match: $isComposeFontComplexMatch"
    Write-Output "ComposeFontSimple Match: $isComposeFontSimpleMatch"
    Write-Output "MarkCommentsWith Match: $isMarkCommentsWithMatch"
    Write-Output "ReplyFontComplex Match: $isReplyFontComplexMatch"
    Write-Output "ReplyFontSimple Match: $isReplyFontSimpleMatch"
    Write-Output "TextFontComplex Match: $isTextFontComplexMatch"
    Write-Output "TextFontSimple Match: $isTextFontSimpleMatch"

    # Determine Overall Status
    if ($isComposeFontComplexMatch -and `
        $isComposeFontSimpleMatch -and `
        $isMarkCommentsWithMatch -and `
        $isReplyFontComplexMatch -and `
        $isReplyFontSimpleMatch -and `
        $isTextFontComplexMatch -and `
        $isTextFontSimpleMatch) {

        Write-Output "Font Settings Outlook are set correctly."
        exit 0
    } else {
        Write-Output "Font Settings Outlook are NOT set correctly."
        exit 1
    }

    } catch {
    Write-Output "An error occurred: $_"
    exit 1
}
