<#PSScriptInfo

.VERSION 1.7
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
    2024-08-15, 1.6:    Added support for http and ftp.
    2025-03-14, 1.7:    Added optional LogoURL parameter.

#> 

<# 

.DESCRIPTION 
Start-SplashScreen is a PowerShell script designed to execute a series of scripts with a user-friendly graphical interface. It provides a visual representation of the script execution process, including progress updates and a status indicator. The script also offers the ability to open the running PowerShell terminal window for troubleshooting or additional actions.

.EXAMPLE
$Scripts2run = @(
  @{
    Name = "Dummy Wait for 15s"
    Script = "Start-Sleep -s 15"
  },
  @{
    Name = "Windows Quality Updates"
    Script = "https://raw.githubusercontent.com/FlorianSLZ/OSDCloud-Stuff/main/OOBE/Windows-Updates_Quality.ps1"
  }
)

Start-SplashScreen.ps1 -Processes $Scripts2run -LogoURL "https://scloud.work/wp-content/uploads/2023/08/terminal-logo-scloud.png"

#> 

param (
    [parameter(Mandatory = $true, HelpMessage = "Specify the processes by name and PowerShell-command or https-link.")]
    [array]$Processes,
    
    [parameter(Mandatory = $false, HelpMessage = "Main message on the Splash Screen.")]
    [string]$MessageHeader = "Windows Preparation",
    
    [parameter(Mandatory = $false, HelpMessage = "Initial message where the script names will show on the Splash Screen.")]
    [string]$MessageText = "Initiate Installation",
    
    [parameter(Mandatory = $false, HelpMessage = "Initial status indicator on the Splash Screen.")]
    [string]$MessageStatus = "...",

    [parameter(Mandatory = $false, HelpMessage = "Finishing message before Splash Screen closes.")]
    [string]$MessageFinished = "All processes finished. This window closes automatically.", 

    [parameter(Mandatory = $false, HelpMessage = "Time until Splash Screen closes after finishing.")]
    [int]$ClosingTimer = 5,

    [parameter(Mandatory = $false, HelpMessage = "Background color of the Splash Screen. Eg. #CCf4f4f4 (CC = 80% transparent) or #f4f4f4")]
    [string]$ColorBackground = "#f4f4f4", 

    [parameter(Mandatory = $false, HelpMessage = "Text color of the Splash Screen. Eg. #161616")]
    [string]$ColorText = "#161616",

    [parameter(Mandatory = $false, HelpMessage = "Optional Logo URL.")]
    [string]$LogoURL = ""
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
      <Image Name="LogoImage" Width="200" Height="200" Margin="0,0,0,20" Visibility="Hidden"/>
      <TextBlock Name="TextMessageHeader" Text="$MessageHeader" FontSize="32" FontWeight="Bold" TextAlignment="Center" />
      <TextBlock Name="TextMessageBody" Text="$MessageText" FontSize="16" TextWrapping="Wrap" TextAlignment="Center" FontStyle="Italic" Margin="0,20,0,20" />
      <TextBlock Name="TextMessageStatus" Text="$MessageStatus" FontSize="18" FontWeight="Bold" TextAlignment="Center"/>
    </StackPanel>
    <Button Grid.Row="1" Name="ShowTerminal" Content="" HorizontalAlignment="Stretch" Background="Transparent" BorderThickness="0" />
  </Grid>
</Window>
"@

# Load XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Load the logo if provided
$LogoImage = $Window.FindName("LogoImage")
if (-not [string]::IsNullOrWhiteSpace($LogoURL)) {
    try {
        $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
        $bitmap.BeginInit()
        $bitmap.UriSource = New-Object System.Uri($LogoURL)
        $bitmap.EndInit()
        $LogoImage.Source = $bitmap
        $LogoImage.Visibility = "Visible"
    }
    catch {
        Write-Warning "Failed to load logo from $LogoURL"
    }
}

# UI Elements
$messageScreenText = $Window.FindName("TextMessageBody")
$messageScreenStatus = $Window.FindName("TextMessageStatus")

$ShowTerminalButton = $Window.FindName("ShowTerminal")
$ShowTerminalButton.Add_Click({ Show-Console })

# Show/Hide Console Functions
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
    [Console.Window]::SetForegroundWindow($consolePtr)
}

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)
}

# Show the window
# Hide-Console
$Window.Show() | Out-Null

# Process scripts
$counter = 0 
$total = $Processes.Count
foreach ($script in $Processes) {
    $counter++
    $messageScreenText.Text = "$($script.Name)"
    $messageScreenStatus.Text = "($counter/$total)"

    $Window.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [System.Action]{})

    if ($script.Script -match "^https?://" -or $script.Script -match "^http://" -or $script.Script -match "^ftp://") {
        Write-Output "($counter/$total) - Running online script: $($script.Script)"
        $WebClient = New-Object System.Net.WebClient
        $WebPSCommand = $WebClient.DownloadString("$($script.Script)")
        Invoke-Expression -Command $WebPSCommand
        $WebClient.Dispose()
    } else {
        Write-Output "($counter/$total) - Running PowerShell command: $($script.Script)"
        Invoke-Expression $($script.Script)
    }
}

$messageScreenText.Text = $MessageFinished
for ($i = $ClosingTimer; $i -gt 0; $i--) {
    $messageScreenStatus.Text = "$i Seconds"
    $Window.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [System.Action]{})
    Start-Sleep -Seconds 1
}

$Window.Close()
Show-Console
