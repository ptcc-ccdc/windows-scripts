##So to anyone reading this, I couldnt find a way to reactivate automatic updates so all ikm doing is updating the signatures and turning it on.
# Update Windows Defender definitions
Write-Host "Updating Windows Defender definitions..."
Update-MpSignature

# Wait for updates to be installed
Start-Sleep -Seconds 60

# Turn on Windows Defender
Write-Host "Turning on Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $false

# Enable forced User Account Control (UAC)
Write-Host "Enabling forced User Account Control (UAC)..."
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1

# Enable audit policy to log changes
Write-Host "Enabling audit policy to log changes..."
auditpol /set /subcategory:"Other System Events" /success:enable /failure:enable
auditpol /set /subcategory:"Security System Extension" /success:enable /failure:enable
auditpol /set /subcategory:"Security State Change" /success:enable /failure:enable

Write-Host "Forced UAC enabled and auditing of changes enabled."

#Immediatly starts a windows defender scan
Start-MpScan -ScanType QuickScan

