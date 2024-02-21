# Set the NTP server to 172.20.242.200
$ntpServer = "172.20.242.200"
w32tm /config /manualpeerlist:$ntpServer /syncfromflags:manual /reliable:YES /update
Restart-Service w32time

# Open the NTP port (UDP 123) for NTP syncs
$ruleName = "NTP Port UDP 123"
$port = 123
$protocol = "UDP"
$ruleExists = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if (-not $ruleExists) {
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -LocalPort $port -Protocol $protocol -Action Allow
} else {
    Write-Host "Firewall rule '$ruleName' already exists."
}
