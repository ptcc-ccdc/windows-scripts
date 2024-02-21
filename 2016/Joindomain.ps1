# Add the computer to the domain "Allsafe.com"
$domain = "Allsafe.com"
$credential = Get-Credential
Add-Computer -DomainName $domain -Credential $credential

# Change the primary DNS server to 172.20.242.200
$networkInterface = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
$interfaceIndex = $networkInterface.ifIndex
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses 172.20.242.200

Restart-Computer -Force