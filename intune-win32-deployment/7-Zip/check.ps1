$choco_id= "7zip"

$choco_path = "C:\ProgramData\chocolatey\lib\$choco_id"
if (Test-Path -Path $choco_path -PathType Container){
    Write-Host "Found it!"
}

