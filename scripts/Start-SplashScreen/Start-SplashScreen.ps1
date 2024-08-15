<#PSScriptInfo

.VERSION 1.5
.GUID b00d1997-e5da-4af1-86f0-92120cfab2f3
.AUTHOR Florian Salzmann
.COMPANYNAME scloud.work
.COPYRIGHT 2024 Florian Salzmann. GPL-3.0 license.
.TAGS Windows SplashScreen PowerShell
.LICENSEURI https://github.com/FlorianSLZ/scloud/blob/main/LICENSE
.PROJECTURI https://github.com/FlorianSLZ/scloud/tree/main/scripts/Start-SplashScreen
.ICONURI https://scloud.work/wp-content/uploads/Start-SplashScreen.webp
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
    2024-08-09, 1.0:    Original published version.
    2024-08-13, 1.1:    New icon, always in front. 
    2024-08-14, 1.2:    Removed OSDCloud dependency.
    2024-08-14, 1.3:    -UseBasicParsing added to Invoke-WebRequest.
    2024-08-14, 1.4:    Removed "Topmost" to allow better troubleshooting.
    2024-08-15, 1.5:    Optimized online script handling.

#> 

<# 

.DESCRIPTION 
Start-SplashScreen is a PowerShell script designed to execute a series of scripts with a user-friendly graphical interface. It provides a visual representation of the script execution process, including progress updates and a status indicator. The script also offers the ability to open the running PowerShell terminal window for troubleshooting or additional actions.

#> 


param (
    [parameter(Mandatory = $true, HelpMessage = "Specify the processes by name and powershell-command or https-link. ")]
    [array]$Processes,
    
    [parameter(Mandatory = $false, HelpMessage = "Main message on the Splash Screen.")]
    [string]$MessageHeader = "Windows Preperation",
    
    [parameter(Mandatory = $false, HelpMessage = "Initla message where the script names will show on the Splash Screen (should appear less than a second).")]
    [string]$MessageText = "Initiate Installation",
    
    [parameter(Mandatory = $false, HelpMessage = "Initla status idendicator on the Splash Screen (should appear less than a second).")]
    [string]$MessageStatus = "...",

    [parameter(Mandatory = $false, HelpMessage = "Finishing message befor Splash Screen closes")]
    [string]$MessageFinished = "All processes finished. This window closes automatically. ", 

    [parameter(Mandatory = $false, HelpMessage = "Time until Splash Screen closes after finishing")]
    [int]$ClosingTimer = 5,

    [parameter(Mandatory = $false, HelpMessage = "Background color of the Splash Screen. Eg. #CCf4f4f4 (CC = 80% transparent) or #f4f4f4")]
    [string]$ColorBackground = "#f4f4f4", 

    [parameter(Mandatory = $false, HelpMessage = "Text color of the Splash Screen. Eg. #161616")]
    [string]$ColorText = "#161616"

)


Add-Type -AssemblyName PresentationFramework
[XML]$xaml = @"
<Window 
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="$MessageHeader"
  WindowStartupLocation="CenterScreen"
  WindowStyle="None"
  AllowsTransparency="True"
  WindowState="Maximized"
  ShowInTaskbar="False" 
  Background="$ColorBackground"
  Foreground="$ColorText"
  >
  <Grid>
    <Grid.RowDefinitions>
      <RowDefinition Height="*"/>
      <RowDefinition Height="75"/>
    </Grid.RowDefinitions>
    <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
      <TextBlock Name="TextMessageHeader" Text="$MessageHeader" FontSize="32" FontWeight="Bold" TextAlignment="Center" />
      <TextBlock Name="TextMessageBody" Text="$MessageText" FontSize="16" TextWrapping="Wrap" TextAlignment="Center" FontStyle="Italic" Margin="0,20,0,20" />
      <TextBlock Name="TextMessageStatus" Text="$MessageStatus" FontSize="18" FontWeight="Bold" TextAlignment="Center"/>
    </StackPanel>
    <Button Grid.Row="1" Name="ShowTerminal" Content="" HorizontalAlignment="Stretch" Background="Transparent" BorderThickness="0" />
  </Grid>
</Window>
"@
<#

#>

# Load XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Create a DispatcherTimer for the "Later" button action
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromMinutes(15)
$timer.Add_Tick({
    $timer.Stop()
    $Window.Show()
}) 


$messageScreenText = $Window.FindName("TextMessageBody")
$messageScreenStatus = $Window.FindName("TextMessageStatus")

$ShowTerminalButton = $Window.FindName("ShowTerminal")
$ShowTerminalButton.Add_Click({ Show-Console })


# Credits to - http://powershell.cz/2013/04/04/hide-and-show-console-window-from-gui/
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
'

function Show-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 5)
    [Console.Window]::SetForegroundWindow($consolePtr) # Bring the window to the front
}

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)
}




# Show the window
#Hide-Console
$Window.Show() | Out-Null


$counter = 0 
$total = $Processes.Count
foreach ($script in $Processes) {
    $counter++
    $messageScreenText.Text = "$($script.Name)"
    $messageScreenStatus.Text = "($counter/$total)"

    
    $Window.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [System.Action]{})


    # Check if the value is a URL (starts with "http") 
    if ($script.Script -match "^https?://") {
        Write-Output "($counter/$total) - Running online script: $($script.Script)"
        $ScriptFile = Invoke-WebRequest $($script.Script) -UseBasicParsing
        $ScriptBlock = [Scriptblock]::Create($ScriptFile.Content) 
        Invoke-Command -ScriptBlock $ScriptBlock
    } else {
      # Directly run the command (assuming it's a string)
      Write-Output "($counter/$total)- Running PowerShell command: $($script.Script)"
      Invoke-Expression $($script.Script)
    }
}


# Update the UI with the final message and countdown timer
$messageScreenText.Text = $MessageFinished

# Countdown loop
for ($i = $ClosingTimer; $i -gt 0; $i--) {
    $messageScreenStatus.Text = "$i Seconds"

    # Update the UI
    $Window.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [System.Action]{})
    
    # Wait for 1 second
    Start-Sleep -Seconds 1
}

# Close the window after the countdown
$Window.Close()

Show-Console
