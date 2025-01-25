# Variables
$DomainName = "Allsafe.com"
$DnsServer = "ALLSAFE-DC1" # Replace with the DNS server name
$KeyAlgorithm = "RSASHA256"
$KSKKeyLength = 2048
$ZSKKeyLength = 1024
$ZoneFilePath = "C:\Windows\System32\dns\$DomainName.dns"

# 1. Enable DNSSEC on the DNS Server
Write-Host "Enabling DNSSEC on the DNS server ($DnsServer)..."
Add-DnsServerSigningKey -ZoneName $DomainName -KeyType KSK -Algorithm $KeyAlgorithm -KeyLength $KSKKeyLength -ComputerName $DnsServer -PassThru
Add-DnsServerSigningKey -ZoneName $DomainName -KeyType ZSK -Algorithm $KeyAlgorithm -KeyLength $ZSKKeyLength -ComputerName $DnsServer -PassThru

# 2. Sign the Zone
Write-Host "Signing the DNS zone on $DnsServer..."
Invoke-DnsServerZoneSign -Name $DomainName -ComputerName $DnsServer -Force

# 3. Verify DNSSEC configuration
Write-Host "Verifying DNSSEC configuration on $DnsServer..."
$DnssecStatus = Get-DnsServerZone -Name $DomainName -ComputerName $DnsServer | Select-Object -ExpandProperty IsSigned
if ($DnssecStatus) {
    Write-Host "DNSSEC has been successfully enabled and configured for the domain: $DomainName on $DnsServer" -ForegroundColor Green
} else {
    Write-Host "Failed to configure DNSSEC for the domain: $DomainName on $DnsServer" -ForegroundColor Red
    exit 1
}

# 4. Export the DS record for parent zone submission
Write-Host "Exporting DS record for parent zone submission..."
$DSRecords = Get-DnsServerDnsSecZoneSetting -ZoneName $DomainName -ComputerName $DnsServer | Select-Object -ExpandProperty KeySigningKeys | ForEach-Object {
    $_ | Get-DnsServerResourceRecord -ZoneName $DomainName | Where-Object { $_.RecordType -eq 'DNSKEY' }
}

$DSRecordPath = "C:\DNSSEC_DS_Record_$DomainName.txt"
$DSRecords | Out-File -FilePath $DSRecordPath
Write-Host "DS record exported to: $DSRecordPath"
Write-Host "Submit the DS record to your domain registrar to complete the DNSSEC chain of trust." -ForegroundColor Yellow

# 5. Enable DNSSEC validation on the DNS server
Write-Host "Enabling DNSSEC validation on the DNS server ($DnsServer)..."
Set-DnsServerDnsSecZoneSetting -Name $DomainName -ValidationEnabled $true -ComputerName $DnsServer
Write-Host "DNSSEC validation is enabled."

# 6. Restart DNS Server service
Write-Host "Restarting DNS Server service on $DnsServer to apply changes..."
Restart-Service -Name "DNS" -Force

Write-Host "DNSSEC configuration for $DomainName is complete on $DnsServer!" -ForegroundColor Green
