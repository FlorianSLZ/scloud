Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\WIN-S-D-RemoveHPWolfSecurity.log" -Force

    ##Remove Wolf Security
    wmic product where "name='HP Wolf Security'" call uninstall
    wmic product where "name='HP Wolf Security - Console'" call uninstall
    wmic product where "name='HP Security Update Service'" call uninstall

Stop-Transcript
