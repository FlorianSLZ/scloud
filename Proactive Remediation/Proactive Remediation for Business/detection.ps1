$DesctopItems_copy = Get-ChildItem "C:\Users\*\Desktop\*- Copy*"
If($DesctopItems_copy){return 1} # exit 1 = detectet, remediation needed