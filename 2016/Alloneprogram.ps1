# Removing unneeded network adapters

# Clear and Uninstall the last 5 network adapters
$networkAdapters = Get-NetAdapter | Select-Object -Skip 1 | Select-Object -Last 5
foreach ($adapter in $networkAdapters) {
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false
    # Uninstall-NetAdapter -Name $adapter.Name -Confirm:$false
}
Write-Host "Disabled all but 1 adapter"
Write-Host "If you want make sure to uninstall in device manager"

# ------------------------------------------------------------
# Setting Ip Addresses

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

Write-Host "Ip addresses and dns servers set for basic setup"

# ------------------------------------------------------------
# Downloads

New-Item -ItemType "directory" -Path "c:\downloads"
Set-Location c:\downloads

#Only allow downloads that use TLS 1.2 and TLS 1.3
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Invoke-WebRequest https://nmap.org/dist/nmap-7.94-setup.exe -Outfile nmap.exe
Invoke-WebRequest https://download.sysinternals.com/files/Autoruns.zip -Outfile Autoruns.zip
Invoke-WebRequest https://sourceforge.net/projects/processhacker/files/processhacker2/processhacker-2.39-setup.exe/download -OutFile processhacker-2.39-setup.exe
Invoke-WebRequest https://2.na.dl.wireshark.org/win64/Wireshark-4.2.2-x64.exe -OutFile Wireshark-4.2.2-x64.exe

Write-Host "Starting apps downloaded in c:\downloads"

# ------------------------------------------------------------
# Defender fixes????

##So to anyone reading this, I couldnt find a way to reactivate automatic updates so all ikm doing is updating the signatures and turning it on.
# Update Windows Defender definitions
Write-Host "Updating Windows Defender definitions..."
Update-MpSignature

# Wait for updates to be installed
Start-Sleep -Seconds 60

# Turn on Windows Defender
Write-Host "Turning on Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $false

# ------------------------------------------------------------
# Reg Edits

# Enable forced User Account Control (UAC)
Write-Host "Enabling forced User Account Control (UAC)..."
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1



# ------------------------------------------------------------
# Audit policies

# Enable audit policy to log changes
Write-Host "Enabling audit policy to log changes..."
auditpol /set /subcategory:"Other System Events" /success:enable /failure:enable
auditpol /set /subcategory:"Security System Extension" /success:enable /failure:enable
auditpol /set /subcategory:"Security State Change" /success:enable /failure:enable

Write-Host "Forced UAC enabled and auditing of changes enabled."

#Immediatly starts a windows defender scan
Start-MpScan -ScanType QuickScan

# ------------------------------------------------------------
# Firewall Rules

# Delete all existing inbound rules
Get-NetFirewallRule -Direction Inbound | Remove-NetFirewallRule

# Disable all inbound traffic while allowing outbound traffic
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block -DefaultOutboundAction Allow

# Enable the ICMPv4 Echo Request rule if it's disabled
Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)"

Write-Host "Inbound Rules absolutly fucked"

