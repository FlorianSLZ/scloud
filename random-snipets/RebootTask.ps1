# Mittags
schtasks /create /tn "Server Reboot - Mittag" /tr "shutdown /r /t 0" /sc DAILY /st 12:00:00 /ru "System" 
# Mitternacht
schtasks /create /tn "Server Reboot - 21.30" /tr "shutdown /r /t 0" /sc DAILY /st 21:30:00 /ru "System"
# Mitternacht
schtasks /create /tn "Server Reboot - Mitternacht" /tr "shutdown /r /t 0" /sc DAILY /st 00:00:00 /ru "System"
# Wöchentlich Samstag auf Sonntag
schtasks /create /tn "Server Reboot - Sonntag Mitternacht" /tr "shutdown /r /t 0" /sc WEEKLY /D SUN /st 00:00:00 /ru "System"
