# Get all active firewall rules and disable them
Get-NetFirewallRule -Enabled True | ForEach-Object {
    $_ | Disable-NetFirewallRule
}