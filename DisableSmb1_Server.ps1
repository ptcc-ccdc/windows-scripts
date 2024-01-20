# Disable SMBv1 protocol, server side
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# Disable SMBv1 server on reboot
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Server -NoRestart

# Verify status of SMBv1 Server Protocol
$SMB1Status = Get-SmbServerConfiguration | Select-Object -ExpandProperty EnableSMB1Protocol
if (-not $SMB1Status) {
    Write-Host "SMBv1 Server Protocol is disabled."
} else {
    Write-Host "SMBv1 Server Protocol is still enabled."
}

# Verify status of SMBv1 Server Feature
$SMB1Feature = Get-WindowsFeature | Where-Object { $_.Name -eq "FS-SMB1" } | Select-Object -ExpandProperty InstallState
if ($SMB1Feature -eq "Removed") {
    Write-Host "SMBv1 Server Feature is disabled."
} else {
    Write-Host "SMBv1 Server Feature is still enabled."
}
