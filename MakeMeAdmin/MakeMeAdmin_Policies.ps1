$PolicyPath = "HKLM:\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"

# Policy Keys
$PolicyKeysJson = '[
{"Name":"Allowed Entities","Value":"","Format":"MultiString"},
{"Name":"Denied Entities","Value":"","Format":"MultiString"},
{"Name":"Automatic Add Allowed","Value":"","Format":"MultiString"},
{"Name":"Automatic Add Denied","Value":"","Format":"MultiString"},
{"Name":"Remote Allowed Entities","Value":"","Format":"MultiString"},
{"Name":"Remote Denied Entities","Value":"","Format":"MultiString"},
{"Name":"syslog servers","Value":"","Format":"MultiString"},
{"Name":"Timeout Overrides","Value":"","Format":"String"},
{"Name":"Admin Rights Timeout","Value":"15","Format":"DWord"},
{"Name":"Remove Admin Rights On Logout","Value":"1","Format":"DWord"},
{"Name":"Override Removal By Outside Process","Value":"1","Format":"DWord"},
{"Name":"Allow Remote Requests","Value":"0","Format":"DWord"},
{"Name":"End Remote Sessions Upon Expiration","Value":"1","Format":"DWord"}
]'

$PolicyKeysConfig = $PolicyKeysJson | ConvertFrom-Json -ErrorAction Stop

if(!(Test-Path $PolicyPath)){New-Item -Path $PolicyPath -Force}

foreach ($Key in $PolicyKeysConfig) {
    if($Key.Value){Set-ItemProperty -Path $PolicyPath -Name $Key.Name -Value $Key.Value -Type $Key.Format}
}
