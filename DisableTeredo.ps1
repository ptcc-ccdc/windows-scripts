Write-Host "Disabling Teredo..."
Set-NetTeredoConfiguration -Type Disabled

# Verify the status of Teredo
$teredoStatus = Get-NetTeredoConfiguration
Write-Host "Teredo status: " $teredoStatus.Type
