Import-Module ActiveDirectory

$userName = "Chief"

# Define the list of groups
$groupNames = @(
    "Enterprise Admins",
    "Group Policy Creator Owners",
    "Schema Admins"
)


foreach ($groupName in $groupNames) {
    try {
        $group = Get-ADGroup -Identity $groupName -ErrorAction Stop
        # Add the user to the group
        Add-ADGroupMember -Identity $group -Members $userName -ErrorAction Stop
        Write-Host "User '$userName' added to group '$groupName'"
    } catch {
        Write-Error "An error occurred: $_. It's possible the group '$groupName' does not exist or other issue."
    }
}
