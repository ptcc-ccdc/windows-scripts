# Define variables
$DomainController = "ALLSAFE-DC1"   # The name of your Domain Controller
$DomainComputer = "PENGUINATOR"    # The name of the domain-joined computer
$NtpServer = "time.windows.com,0x9"  # External NTP server for the Domain Controller

# Function to configure the PDC Emulator (ALLSAFE-DC1)
function Configure-DomainController {
    Write-Host "Configuring domain controller: $DomainController" -ForegroundColor Green

    try {
        # Set registry keys directly (since this is running locally on the domain controller)
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NTP"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "NtpServer" -Value $NtpServer
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "AnnounceFlags" -Value 5
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Name "MaxPosPhaseCorrection" -Value 0xFFFFFFFF
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Name "MaxNegPhaseCorrection" -Value 0xFFFFFFFF

        # Restart the Windows Time service
        Restart-Service -Name "w32time"

        # Force time synchronization
        w32tm /resync

        Write-Host "Domain controller configuration complete." -ForegroundColor Green
    } catch {
        Write-Host "Failed to configure domain controller: $_" -ForegroundColor Red
    }
}

# Function to configure a domain-joined computer (PENGUINATOR)
function Configure-DomainComputer {
    Write-Host "Configuring domain computer: $DomainComputer" -ForegroundColor Green

    try {
        # Use WMI to set registry values and restart the Windows Time service on the remote computer
        # Registry: HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
        Invoke-WmiMethod -ComputerName $DomainComputer -Namespace "root\default" -Class "StdRegProv" -Name SetStringValue -ArgumentList @{
            sSubKeyName = "SYSTEM\CurrentControlSet\Services\W32Time\Parameters";
            sValueName = "Type";
            sValue = "NT5DS"
        }

        # Remove the "NtpServer" registry value if it exists
        Invoke-WmiMethod -ComputerName $DomainComputer -Namespace "root\default" -Class "StdRegProv" -Name DeleteValue -ArgumentList @{
            sSubKeyName = "SYSTEM\CurrentControlSet\Services\W32Time\Parameters";
            sValueName = "NtpServer"
        }

        # Restart the Windows Time service
        Invoke-WmiMethod -ComputerName $DomainComputer -Namespace "root\cimv2" -Class Win32_Service -Name StartService -ArgumentList @{
            Name = "w32time"
        }

        # Force time synchronization (use w32tm remotely)
        Invoke-Command -ComputerName $DomainComputer -ScriptBlock { w32tm /resync } -ErrorAction SilentlyContinue

        Write-Host "Domain computer configuration complete." -ForegroundColor Green
    } catch {
        Write-Host "Failed to configure domain computer: $_" -ForegroundColor Red
    }
}

# Execute the functions
Configure-DomainController
Configure-DomainComputer
