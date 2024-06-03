# Install required Windows features
Install-WindowsFeature -Name DHCP, Hyper-V -IncludeManagementTools

# Enable Hyper-V feature using dism
dism /Online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All

# Here you need to restart your VM

# Define the name for the virtual switch
$switchName = "vSwitchIntDHCP"

# Create a new internal virtual switch
New-VMSwitch -Name $switchName -SwitchType Internal

# Create a new Network Address Translation (NAT) configuration for the virtual switch
New-NetNat -Name $switchName -InternalIPInterfaceAddressPrefix "10.1.97.0/24"

# Get the interface index of the virtual switch
$ifIndex = (Get-NetAdapter | ? {$_.name -like "*$switchName)"}).ifIndex

# Assign an IP address to the virtual switch
New-NetIPAddress -IPAddress 10.1.97.1 -InterfaceIndex $ifIndex -PrefixLength 24

# Add a DHCP scope for the virtual switch
Add-DhcpServerV4Scope -Name "DHCP-$switchName" -StartRange 10.1.97.50 -EndRange 10.1.97.100 -SubnetMask 255.255.255.0

# Set DHCP server options
Set-DhcpServerV4OptionValue -Router 10.1.97.1 -DnsServer 168.63.129.16

# Restart the DHCP server service
Restart-Service dhcpserver
