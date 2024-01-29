##So to anyone reading this, I couldnt find a way to reactivate automatic updates so all ikm doing is updating the signatures and turning it on.
# Update Windows Defender definitions
Write-Host "Updating Windows Defender definitions..."
Update-MpSignature

# Wait for updates to be installed
Start-Sleep -Seconds 60

# Turn on Windows Defender
Write-Host "Turning on Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $false

#Immediatly starts a windows defender scan
Start-MpScan -ScanType QuickScan