#############################
#	Systray Info
#############################
$SysT_Name = "Helpdesk Info"
$SysT_Folder = "$env:Programdata\$SysT_Name"


#############################
#	Log
#############################
Start-Transcript -Path "$SysT_Folder\$SysT_Name-$env:USERNAME.log" -Force


#############################
#	Systray icon
#############################
# Load Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create object for the systray 
$SystrayTool = New-Object System.Windows.Forms.NotifyIcon

# Text displayed when you pass the mouse over the systray icon
$SystrayTool.Text = $SysT_Name

# Systray icon
$SystrayTool.Icon = "$SysT_Folder\icons\icon.ico"
$SystrayTool.Visible = $true


#############################
#	Systray Menu
#############################
# Main Menu
$Menu_Main = New-Object System.Windows.Forms.ContextMenuStrip 

# Hostname
$MenuObj_InfoHostname = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuObj_InfoHostname.Text = ("$($env:computername)")
$MenuObj_InfoHostname.Image = [System.Drawing.Bitmap]::FromFile("$SysT_Folder\icons\monitor.ico")
$Menu_Main.Items.Add($MenuObj_InfoHostname)

# IP address
$MenuObj_InfoIP = New-Object System.Windows.Forms.ToolStripMenuItem
$IP = $((Get-NetIPAddress | Where-Object{ $_.AddressFamily -eq "IPv4"  -and !($_.IPAddress -match "169") -and !($_.IPaddress -match "127") }).IPAddress) | Select-Object -First 1
$MenuObj_InfoIP.Text = ("$IP")
$MenuObj_InfoIP.Image = [System.Drawing.Bitmap]::FromFile("$SysT_Folder\icons\internet.ico")
$Menu_Main.Items.Add($MenuObj_InfoIP)

# Action
$MenuObj_Action = $Menu_Main.Items.Add("Send Support info");
$MenuObj_Action_Picture =[System.Drawing.Bitmap]::FromFile("$SysT_Folder\icons\send.ico")
$MenuObj_Action.Image = $MenuObj_Action_Picture
$MenuObj_Action.add_Click({ 
	$wshell = new-object -comobject wscript.shell
	$intAnswer = $wshell.popup("Would you like to send infos about your PC to the helpdek?", 0,"Send Helpdesk Infos",4)
	if($intAnswer -eq 6) {
	  &"$SysT_Folder\Actions\SendToHelpdesk_Teams.ps1"
	}
})

# Exit
$Menu_Exit = $Menu_Main.Items.Add("Exit");
$Menu_Exit.Image = [System.Drawing.Bitmap]::FromFile("$SysT_Folder\icons\exit.ico")
$Menu_Exit.add_Click({
	$SystrayTool.Visible = $false
	Stop-Process $pid
})
 
# add to menu
$SystrayTool.ContextMenuStrip  = $Menu_Main;


#############################
#	hide and run 
#############################
# hide PS windowcode
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

[System.GC]::Collect()
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)

Stop-Transcript
