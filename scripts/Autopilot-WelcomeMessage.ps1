<#
.SYNOPSIS
    Shows a Welcome/Reboot message to the newly enrolled user. 

.NOTES
    FileName:    Autopilot-WelcomeMessage.ps1
    Author:      Florian Salzmann
    Created:     2024-05-21
    Updated:     2024-05-21

    Version history:
    1.0.0 - (2024-05-21) Script created
#>

Start-Transcript "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Autopilot-WelcomeMessage-Task.log"

# Check Date/Time of device enrollment
$DeviceEnrollmentTime = [datetime]$(Get-Item -Path ('{0}\Microsoft Intune Management Extension' -f (${env:ProgramFiles(x86)})) | Select-Object -ExpandProperty 'CreationTimeUtc')
$hours = 48


if ($(($(Get-Date) - $DeviceEnrollmentTime).TotalHours) -gt $hours) {
    Write-Host "Enroll date [$DeviceEnrollmentTime] was to long ago, will skip this script..."
    $EnrollmentDateOK = $False
} else {

    if ($EnrollmentDateOK -eq $True) {
        Write-Host "Adding scheduled task"


        # Create the PowerShell script that will display the popup
        $psScriptPath = "$env:localappdata\Autopilot-WelcomeMessage.ps1"
        $psScriptContent = @'

Start-Transcript "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Autopilot-WelcomeMessage-$env:username.log"

Add-Type -AssemblyName PresentationFramework

# Localized messages
$localizedMessages = @{
    "EN" = @{
        "MessageHeader" = "Welcome to your new Device"
        "MessageText" = "Your device is almost ready. &#10;It just needs one reboot to apply some last changes. &#10;Press *Reboot* to reboot now or *Later* to postpone it for 15min."
        "ButtonReboot" = "Reboot"
        "ButtonLater" = "Later"
    }
    "DE" = @{
        "MessageHeader" = "Willkommen zu Ihrem neuen Gerät"
        "MessageText" = "Ihr Gerät ist fast fertig. &#10;Es benötigt nur einen Neustart, um einige letzte Änderungen anzuwenden. &#10;Drücken Sie *Neustart*, um jetzt neu zu starten, oder *Später*, um es um 15 Minuten zu verschieben."
        "ButtonReboot" = "Neustart"
        "ButtonLater" = "Später"
    }
    "FR" = @{
        "MessageHeader" = "Bienvenue sur votre nouvel appareil"
        "MessageText" = "Votre appareil est presque prêt. &#10;Il suffit d'un redémarrage pour appliquer les derniers changements. &#10;Appuyez sur *Redémarrer* pour redémarrer maintenant ou sur *Plus tard* pour reporter de 15 minutes."
        "ButtonReboot" = "Redémarrer"
        "ButtonLater" = "Plus tard"
    }
    "IT" = @{
        "MessageHeader" = "Benvenuto nel tuo nuovo dispositivo"
        "MessageText" = "Il tuo dispositivo è quasi pronto. &#10;È necessario solo un riavvio per applicare le ultime modifiche. &#10;Premi *Riavvia* per riavviare ora o *Più tardi* per posticipare di 15 minuti."
        "ButtonReboot" = "Riavvia"
        "ButtonLater" = "Più tardi"
    }
}

# Detect system language
$systemLanguage = (Get-Culture).TwoLetterISOLanguageName.ToUpper()

# Use English as default if system language is not in the localized messages
if ($localizedMessages.ContainsKey($systemLanguage)) {
    $messages = $localizedMessages[$systemLanguage]
} else {
    $messages = $localizedMessages["EN"]
}

# Assign messages
$MessageHeader = $messages["MessageHeader"]
$MessageText = $messages["MessageText"]
$ButtonReboot = $messages["ButtonReboot"]
$ButtonLater = $messages["ButtonLater"]

[XML]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="IntuneWin32 Deployer" 
    Height="200" Width="420"
    WindowStartupLocation="CenterScreen" WindowStyle="None" 
    ShowInTaskbar="False" 
    ResizeMode="NoResize" Background="#FF1B1A19" Foreground="white">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid Grid.Column="1" Margin="10">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Name="TextMessageHeader" Text="$MessageHeader" FontSize="20" VerticalAlignment="Top" HorizontalAlignment="Left"/>
            <TextBlock Name="TextMessageBody" Text="$MessageText" Grid.Row="1" VerticalAlignment="Center" HorizontalAlignment="Left" TextWrapping="Wrap" />
            <StackPanel x:Name="Buttons" Grid.Row="2" Orientation="Horizontal">
                <Button x:Name="ButtonLater" Content="$ButtonLater" Background="#504c49" Foreground="white" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="1" Width="90"/>
                <Button x:Name="ButtonReboot" Content="$ButtonReboot" Background="#46a049" Foreground="white" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="0" Width="90"/>
            </StackPanel>
        </Grid>
    </Grid>
</Window>
"@

# Load XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Event handler for the "Reboot" button
$Window.FindName("ButtonReboot").Add_Click({
    $Window.Close()
    Restart-Computer -Force
})

# Create a DispatcherTimer for the "Later" button action
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromMinutes(15)
$timer.Add_Tick({
    $timer.Stop()
    $Window.Show()
})

# Event handler for the "Later" button
$Window.FindName("ButtonLater").Add_Click({
    $Window.Hide()
    Write-Host "User ($env:username) postponed reboot!"
    $timer.Start()
})

# Show the window
$Window.Show() | Out-Null

# Run the Dispatcher
[System.Windows.Threading.Dispatcher]::Run()


Stop-Transcript 


'@
        $psScriptContent | Out-File -FilePath $psScriptPath -Encoding UTF8

        # Create the VBScript that will run the PowerShell script silently
        $vbsScriptPath = "$env:localappdata\Autopilot-WelcomeMessage.vbs"
        $vbsScriptContent = @'
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File ""' + $psScriptPath + '""", 0, False
'@
        $vbsScriptContent | Out-File -FilePath $vbsScriptPath -Encoding UTF8


        # Create the scheduled task
        $taskName = "Autopilot Welcome Message"

        if (Get-ScheduledTask | Where-Object { $_.TaskName -like $taskName }) {
            Write-Host "The scheduled task already exists, will not recreate it."
        } else {
            # Create the scheduled task
            $time = (Get-Date).AddMinutes(1)
            $action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument "`"$vbsScriptPath`""
            $trigger = New-ScheduledTaskTrigger -At $time -Once
            $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit '00:00:00' -MultipleInstances IgnoreNew
            Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Settings $settings 
        }
    } else {
        Write-Host "The enrollment date was outside of the allowed timeframe, will NOT launch Welcome prompt..."
    }
}

Stop-Transcript