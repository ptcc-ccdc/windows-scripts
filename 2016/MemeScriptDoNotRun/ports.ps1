# Define the list of ports to open
$ports = @(7,9,13,21..23,25..26,37,53,79..81,88,106,110..111,113,119,135,139,143..144,179,199,389,427,443..445,465,513..515,543..544,548,554,587,631,646,873,990,993,995,1025..1029,1110,1433,1720,1723,1755,1900,2000..2001,2049,2121,2717,3000,3128,3306,3389,3986,4899,5000,5009,5051,5060,5101,5190,5357,5432,5631,5666,5800,5900,6000..6001,6646,7070,8000,8008..8009,8080..8081,8443,8888,9100,9999..10000,32768,49152..49157)

# Function to open ports and add firewall rules
function Open-PortsAndAddFirewallRules {
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$PortList
    )

    foreach ($port in $PortList) {
        # Open the port using Netcat
        Start-Process -FilePath "nc.exe" -ArgumentList "-l -p $port" -WindowStyle Hidden

        # Add a firewall rule
        $ruleName = "OpenPort_$port"
        $cmd = "New-NetFirewallRule -DisplayName `"$ruleName`" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow"
        Invoke-Expression $cmd
    }
}

# Function to remove the added firewall rules
function Remove-AddedFirewallRules {
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$PortList
    )

    foreach ($port in $PortList) {
        $ruleName = "OpenPort_$port"
        $cmd = "Remove-NetFirewallRule -DisplayName `"$ruleName`""
        Invoke-Expression $cmd
    }
}

# Open the ports and add firewall rules
Open-PortsAndAddFirewallRules -PortList $ports

# Example usage to remove the added firewall rules
# Remove-AddedFirewallRules -PortList $ports
