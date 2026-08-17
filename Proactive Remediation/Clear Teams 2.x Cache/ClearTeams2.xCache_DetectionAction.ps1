Start-Transcript "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\ClearTeams2.xCache_DetectionAction.log"

$TeamsCache = "C:\Users\$env:UserName\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe"
$BackgroundsPath = "$TeamsCache\LocalCache\Microsoft\MSTeams\Backgrounds"
$ProcessName = "ms-teams"

function Clear-TeamsCache {
    $tempPath = "$env:TEMP\TeamsBackgrounds_Backup"
    if (Test-Path $BackgroundsPath) {
        Copy-Item -Path $BackgroundsPath -Destination $tempPath -Recurse -Force
    }
    Get-ChildItem -Path $TeamsCache -Force | Remove-Item -Force -Recurse
    if (Test-Path $tempPath) {
        New-Item -Path $BackgroundsPath -ItemType Directory -Force | Out-Null
        Get-ChildItem -Path $tempPath -Force | Move-Item -Destination $BackgroundsPath -Force
        Remove-Item -Path $tempPath -Force -Recurse
    }
}

# Check if Teams is running
$Teams = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
# If it is, close & clear the cache
if ($Teams)
{
    Add-Type -AssemblyName PresentationFramework
    $MessageHeader = "We need to clear you Teams cache"
    $MessageText = "We've detected a problem with your Teams client. &#10;To resolve this, we need to clear the cache and restart Teams. &#10;Press *Clear* to continue."
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
                <Button x:Name="ButtonAbort" Content="Abort" Background="#504c49" Foreground="white" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="1" Width="90"/>
                <Button x:Name="ButtonClear" Content="Clear" Background="#46a049" Foreground="white" HorizontalContentAlignment="Center" HorizontalAlignment="Left" Grid.Row="2" Margin="10,0,0,0" Height="28" BorderThickness="0" Width="90"/>
            </StackPanel>
        </Grid>
    </Grid>
</Window>
"@
    # Load XAML
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $Window = [Windows.Markup.XamlReader]::Load($reader)
    # Event handler for the "Clear" button
    $Window.FindName("ButtonClear").Add_Click({
        $Window.Close()
        Stop-Process -Id $Teams.id
        Wait-Process -Id $Teams.id
        Start-Sleep -s 10
        Clear-TeamsCache
        Start-Process $ProcessName
        Write-Host "Cache cleared for $env:username"
        exit 0
    })
    # Event handler for the "Abort" button
    $Window.FindName("ButtonAbort").Add_Click({
        $Window.Close()
        Write-Host "User ($env:username) aborted action!"
        exit 1
    })
    # Show the window
    $Window.ShowDialog() | Out-Null
}
else{
    Clear-TeamsCache
    Write-Host "Cache cleared for $env:username"
    exit 0
}

Stop-Transcript