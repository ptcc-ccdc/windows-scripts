# Disable SMBv1 Server
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# Disable SMBv1 Client
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# Verify SMBv1 Disabled
Get-SmbServerConfiguration | Select EnableSMB1Protocol
Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol | Select State
