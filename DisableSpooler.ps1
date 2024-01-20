# Stopping the Print Spooler service
Stop-Service -Name Spooler -Force

# Disabling the Print Spooler service from starting on boot
Set-Service -Name Spooler -StartupType Disabled

# Status of the Print Spooler service
Get-Service -Name Spooler | Select-Object Status, StartType
