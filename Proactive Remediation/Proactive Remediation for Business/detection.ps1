$DesctopItems_copy = Get-ChildItem "C:\Users\*\Desktop\*- Copy*"
If($DesctopItems_copy){exit 1}else{exit 0} # exit 1 = detectet, remediation needed