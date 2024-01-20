# Stop and disable the SMBv1 client service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10" -Name "Start" -Value 4

# Disable SMBv1 client
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Client -NoRestart

# Verify the status of the SMBv1 Client Feature
$SMB1ClientFeature = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Client
if ($SMB1ClientFeature.State -eq "Disabled") {
    Write-Host "SMBv1 Client Feature is disabled."
} else {
    Write-Host "SMBv1 Client Feature is still enabled."
}

# Verify the status of the SMBv1 Client Service
$SMB1ClientService = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10" -Name "Start"
if ($SMB1ClientService -eq 4) {
    Write-Host "SMBv1 Client Service is disabled."
} else {
    Write-Host "SMBv1 Client Service is still enabled."
}
