# Disable SMBv1 protocol, server side
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# Disable SMBv1 server on reboot
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Server -NoRestart
