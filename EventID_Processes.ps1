# Define the list of process-related event IDs to search for
$eventIDs = @(
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
            EventID = $_.Id
            ProcessName = $eventData['NewProcessName']
            ProcessID = $eventData['NewProcessId']
            SubjectUserSid = $eventData['SubjectUserSid']
            SubjectUserName = $eventData['SubjectUserName']
            SubjectDomainName = $eventData['SubjectDomainName']
            SubjectLogonId = $eventData['SubjectLogonId']
            CreatorProcessName = $eventData['CreatorProcessName']
            CreatorProcessID = $eventData['CreatorProcessId']
            Computer = $eventXml.Event.System.Computer
            Message = $_.Message
        }
    } | Format-Table -AutoSize
    Write-Host "`n" # Newline for readability
}
