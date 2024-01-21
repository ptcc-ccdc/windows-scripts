# Create a new Authentication Policy with Kerberos FAST enabled
$AuthPolicy = New-ADAuthenticationPolicy -Name "KerberosFASTPolicy" -Description "Enable Kerberos Armoring (FAST)" -KerberosFastAuthentication $true

# Retrieve group members
try {
    $users = Get-ADGroupMember -Identity "Domain Users" -ErrorAction Stop
} catch {
    Write-Error "Failed to retrieve group members. Error: $_"
    return
}

# Apply the Authentication Policy to each user
foreach ($user in $users) {
    try {
        Set-ADUser -Identity $user -AuthenticationPolicy $AuthPolicy -ErrorAction Stop
        Write-Host "Applied Kerberos FAST policy to user: $($user.SamAccountName)"
    } catch {
        Write-Error "Failed to apply policy to user: $($user.SamAccountName). Error: $_"
    }
}
