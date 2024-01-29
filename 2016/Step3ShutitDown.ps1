# Get all active firewall rules and disable them except for ICMPv4 Echo Request
Get-NetFirewallRule -Enabled True | ForEach-Object {
    if ($_.DisplayName -ne "File and Printer Sharing (Echo Request - ICMPv4-In)") {
        $_ | Disable-NetFirewallRule
    }
}

# Enable the ICMPv4 Echo Request rule if it's disabled
$icmpRule = Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)"
if ($icmpRule.Enabled -eq $false) {
    $icmpRule | Enable-NetFirewallRule
}
