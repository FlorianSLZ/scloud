$TeamsCache = "C:\Users\$env:UserName\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe"
$ProcessName = "ms-teams" 

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

        # close Teams
        Stop-Process -Id $Teams.id
        Wait-Process -Id $Teams.id
        Start-Sleep -s 10
        # clear the cache, exclude Backgrounds folder
        Get-ChildItem -Path $TeamsCache -Exclude "Backgrounds" | Remove-Item -Recurse -Force
        # Start Teams
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
# If it isn't, clear the cache
else{
    # clear the cache, exclude Backgrounds folder
    Get-ChildItem -Path $TeamsCache -Exclude "Backgrounds" | Remove-Item -Recurse -Force
    Write-Host "Cache cleared for $env:username"
    exit 0
}
