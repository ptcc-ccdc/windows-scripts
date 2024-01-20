# list of event IDs to search for
$eventIDs = @(
    4624, # An account was successfully logged on
    4625, # An account failed to log on
    4720, # A user account was created
    4722, # A user account was enabled
    4723, # An attempt was made to change an account's password
    4725, # A user account was disabled
    4726, # A user account was deleted
    4688, # A new process has been created
    4689  # A process has exited
)

# Loop through each event ID, display the latest events
foreach ($eventID in $eventIDs) {
    Write-Host "Showing latest events for Event ID: $eventID"
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=$eventID} -MaxEvents 25 | Format-Table -Property TimeCreated, Id, Message -AutoSize
    Write-Host "`n" # Newline for readability
}

# Prompt for a specific event ID
$specificEventID = Read-Host "Enter a specific Event ID to search for"
if ($specificEventID -ne '') {
    Write-Host "Showing latest events for Event ID: $specificEventID"
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=$specificEventID} -MaxEvents 25 | Format-Table -Property TimeCreated, Id, Message -AutoSize
}
