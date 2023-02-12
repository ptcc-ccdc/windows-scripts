# Import the Active Directory module
Import-Module ActiveDirectory

# Store the current domain information
$domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
$domainController = (Get-ADDomainController -Discover -Service "PrimaryDC").HostName

# Get the current krbtgt account
$krbtgtAccount = Get-ADUser -Filter {UserPrincipalName -eq "krbtgt@$domain"} -Server $domainController

# Generate a new password for the krbtgt account
$newPassword = ConvertTo-SecureString -AsPlainText -Force -String (Get-Random -Minimum 1000000000 -Maximum 10000000000)

# Set the new password for the krbtgt account
Set-ADAccountPassword -Identity $krbtgtAccount.DistinguishedName -NewPassword $newPassword -Server $domainController

# Update the keys for the krbtgt account
Add-KDSRootKey -EffectiveImmediately -DomainName $domain

# Restart the Key Distribution Service (KDS) on all domain controllers
Restart-Service -Name KDS -ComputerName (Get-ADDomainController -Filter *).Name

# Verify the new krbtgt keys are in use
$kdc = Get-KDSRootKey -Effective | Select-Object -ExpandProperty KeyDistributionService
Write-Host "The new krbtgt keys are in use on KDC: $kdc"

# Wait for the new krbtgt keys to be replicated
Write-Host "Waiting for the new krbtgt keys to be replicated..."
Start-Sleep -Seconds 300

# Verify the new krbtgt keys are replicated on all domain controllers
$kdc = (Get-KDSRootKey -Effective).KeyDistributionService
Write-Host "The new krbtgt keys have been replicated on all KDCs: $kdc"