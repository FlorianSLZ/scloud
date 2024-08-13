<p align="center">
    <a href="https://scloud.work" alt="Florian Salzmann | scloud"></a>
            <img src="https://scloud.work/wp-content/uploads/Start-SplashScreen.webp" width="75" height="75" /></a>
</p>
<p align="center">
    <a href="https://www.linkedin.com/in/fsalzmann/">
        <img alt="Made by" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361">
    </a>
    <a href="https://x.com/FlorianSLZ" alt="X / Twitter">
    	<img src="https://img.shields.io/twitter/follow/FlorianSLZ.svg?style=social"/>
    </a>
</p>
<p align="center">
    <a href="https://www.powershellgallery.com/packages/Start-SplashScreen/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/Start-SplashScreen.svg" />
    </a>
    <a href="https://www.powershellgallery.com/packages/Start-SplashScreen/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/Start-SplashScreen.svg" />
    </a>
</p>
<p align="center">
    <a href="https://github.com/FlorianSLZ/scloud/blob/main/scripts/Start-SplashScreen/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/FlorianSLZ/Start-SplashScreen.svg" />
    </a>
</p>

<p align="center">
	<a href='https://ko-fi.com/G2G211KJI9' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
</p>

# Start-SplashScreen 

The **Start-SplashScreen** script is a PowerShell tool designed to provide a user-friendly graphical interface for executing a series of scripts. The interface displays progress updates, status indicators, and an optional countdown timer before closing. It also offers the ability to toggle the visibility of the PowerShell console, allowing for troubleshooting or additional actions.

## Features 

- **Graphical Interface**: Displays a splash screen with a customizable title, messages, and status indicators.
- **Process Execution**: Executes a list of specified scripts or commands, displaying their progress on the splash screen.
- **Console Visibility Control**: Includes buttons to show or hide the PowerShell console window.
- **Customizable Appearance**: Background and text colors can be customized via parameters.
- **Countdown Timer**: Displays a countdown before automatically closing the splash screen after all processes have finished.

## Requirements

- Windows operating system.
- PowerShell 5.1 or later.

## Installation

```powershell
Install-Module -Name IntuneBulkMaster 
```

## Usage

```powershell
.\Start-SplashScreen.ps1 -Processes $ProcessesArray 

.\Start-SplashScreen.ps1 -Processes $ProcessesArray -MessageHeader "Custom Header" -MessageText "Initializing..." -MessageStatus "Loading..." -MessageFinished "Done!" -ClosingTimer 10 -ColorBackground "#FFFFFF" -ColorText "#000000"

```

## Parameters
- Processes (Required): An array of processes to run, specified by name and command or URL.
- MessageHeader (Optional): Main message on the Splash Screen. Default: "Windows Preparation".
- MessageText (Optional): Initial message on the Splash Screen. Default: "Initiate Installation".
- MessageStatus (Optional): Initial status indicator on the Splash Screen. Default: "...".
- MessageFinished (Optional): Final message before the Splash Screen closes. Default: "All processes finished. This window will automatically close in".
- ClosingTimer (Optional): Time in seconds until the Splash Screen closes after finishing. Default: 5.
- ColorBackground (Optional): Background color of the Splash Screen. Default: "#CCf4f4f4".
- ColorText (Optional): Text color on the Splash Screen. Default: "#161616".

```powershell
$ProcessesArray = @(
    @{ Name = "Process 1"; Script = "Start-Service MyService" },
    @{ Name = "Process 2"; Script = "https://example.com/script.ps1" }
)

.\Start-SplashScreen.ps1 -Processes $ProcessesArray -MessageHeader "Setup in Progress" -MessageFinished "Installation Complete!" -ClosingTimer 10
```
In this example, the splash screen displays a header "Setup in Progress" while executing two processes. The screen will close automatically after 10 seconds once the processes are complete.

