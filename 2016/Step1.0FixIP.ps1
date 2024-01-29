# Clear and Uninstall the last 5 network adapters
$networkAdapters = Get-NetAdapter | Select-Object -Skip 1 | Select-Object -Last 5
foreach ($adapter in $networkAdapters) {
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false
    Uninstall-NetAdapter -Name $adapter.Name -Confirm:$false
}

# Set IP configuration for the first network adapter
$firstAdapter = Get-NetAdapter | Select-Object -First 1
$ipAddress = "172.20.240.10"
$defaultGateway = "172.20.240.254"
$dnsServers = "8.8.8.8", "1.1.1.1"

# Set the IP address, subnet mask, and default gateway
$IPAddressConfig = @{
    IPAddress        = $ipAddress
    InterfaceIndex   = $firstAdapter.InterfaceIndex
    AddressFamily    = "IPv4"
    PrefixLength     = 24
}
$GatewayConfig = @{
    NextHop          = $defaultGateway
    InterfaceIndex   = $firstAdapter.InterfaceIndex
}

# Set DNS server addresses
$DnsConfig = @{
    ServerAddresses  = $dnsServers
    InterfaceIndex   = $firstAdapter.InterfaceIndex
}

# Set IP configuration
Set-NetIPAddress @IPAddressConfig
Set-NetIPInterface -InterfaceIndex $firstAdapter.InterfaceIndex -Dhcp Disabled
Set-NetIPInterface -InterfaceIndex $firstAdapter.InterfaceIndex -DefaultGateway $GatewayConfig
Set-DnsClientServerAddress @DnsConfig