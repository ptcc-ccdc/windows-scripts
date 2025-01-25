# Define variables
$DomainController = "ALLSAFEDC-1"   # Your Domain Controller
$DomainName = "Allsafe.com"         # Your Domain Name
$GPOName = "Disable LM Hashes"      # GPO Name for Disabling LM Hash Usage

# Import Group Policy Module
Import-Module GroupPolicy

# Create or retrieve the GPO
$GPO = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue
if (!$GPO) {
    Write-Host "Creating new GPO: $GPOName" -ForegroundColor Yellow
    $GPO = New-GPO -Name $GPOName
}

# Set "Do not store LAN Manager hash value on next password change"
Write-Host "Configuring GPO to prevent LM hash storage..." -ForegroundColor Yellow
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "NoLMHash" -Type DWORD -Value 1

# Set "LAN Manager authentication level" to "Send NTLMv2 response only. Refuse LM & NTLM."
Write-Host "Configuring GPO to set LAN Manager authentication level..." -ForegroundColor Yellow
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "LmCompatibilityLevel" -Type DWORD -Value 5

# Link GPO to the domain root
Write-Host "Linking GPO to the domain root ($DomainName)..." -ForegroundColor Yellow
New-GPLink -Name $GPOName -Target "DC=Allsafe,DC=com" -Enforced

# Force GPO Update
Write-Host "Forcing Group Policy update on domain controller ($DomainController)..." -ForegroundColor Yellow
gpupdate /force

# Inform the user
Write-Host "LM Hash usage has been successfully disallowed for the domain ($DomainName)." -ForegroundColor Green
