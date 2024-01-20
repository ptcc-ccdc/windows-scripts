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

# Loop through each event ID and display the latest events with details
foreach ($eventID in $eventIDs) {
    Write-Host "Showing detailed latest events for Event ID: $eventID"
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=$eventID} -MaxEvents 5 | ForEach-Object {
        # Parse the event XML data
        $eventXml = [xml] $_.ToXml()
        $eventData = @{}
        foreach ($data in $eventXml.Event.EventData.Data) {
            $eventData[$data.Name] = $data.'#text'
        }
        
        # Create a custom object for each event to display detailed information
        [PSCustomObject] @{
            TimeCreated = $_.TimeCreated
            Id = $_.Id
            User = $eventData['TargetUserName']
            Computer = $eventXml.Event.System.Computer
            Message = $_.Message
            ProcessName = if ($eventID -eq 4688) { $eventData['NewProcessName'] }
            ProcessId = if ($eventID -eq 4688) { $eventData['NewProcessId'] }
        }
    } | Format-Table -AutoSize
    Write-Host "`n" # Newline for readability
}
