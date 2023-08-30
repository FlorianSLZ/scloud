$Users_all = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\Scripts\Reports"

foreach($User in $Users_all){
    $User.PSChildName

    $Remediations_all = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\Scripts\Reports\$($User.PSChildName)"

    foreach($Remediation in $Remediations_all){

        Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\Scripts\Reports\$($User.PSChildName)\$($Remediation.PSChildName)\Result" | Select-Object -ExpandProperty Result | ConvertFrom-Json | fl *Output*

    }


}
