Start-Transcript "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\ClearTeams2.xCache_DetectionAction.log"

$CacheFolder = "$env:LOCALAPPDATA\Microsoft\Office\16.0\Wef"
$ProcessName = "OUTLOOK", "WINWORD", "EXCEL", "POWERPNT", "ONENOTE", "WINPROJ", "VISIO"

# Check if blocking apps are running
$ActiveProcesses = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue

# If it is, close & clear the cache
if ($ActiveProcesses)
{

    Add-Type -AssemblyName PresentationFramework

    $MessageHeader = "We need to clear your Microsoft 365 Apps cache"
    $MessageText = "
We've detected a problem with your Microsoft 365 Apps. 
&#10;
To fix this, we need to clear your cache and close all of your Microsoft 365 Apps. 
&#10;
&#10;
Press *Clear* to continue.
"

    [XML]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="IntuneWin32 Deployer" 
    Height="200" Width="500"
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

        # close Microsft 365 Apps
        Stop-Process -Id $ActiveProcesses.id
        Wait-Process -Id $ActiveProcesses.id
        Start-Sleep -s 10
        # clear the cache
        Get-ChildItem -Path $CacheFolder  | Remove-Item -Recurse -Force


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
# If it isn't, clear the cache
else{
    # clear the cache
    Get-ChildItem -Path $CacheFolder | Remove-Item -Recurse -Force
    Write-Host "Cache cleared for $env:username"
    exit 0
}


Stop-Transcript