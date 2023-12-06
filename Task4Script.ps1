# Randomly generate a new password
$newPassword = -join ((65..90) + (97..122) | Get-Random -Count 6 | % {[char]$_})

# Create an event log source 
$source = "Task4EventSource"


# Write an event log entry with the new password
$timestamp = Get-Date
$message = "[$timestamp] Level 4 Password Update: The new password for user4 is $newPassword"

# Generate an Event ID (can be a constant or based on a simple pattern)
$eventId = 1000  # Example constant Event ID

Write-EventLog -LogName Application -Source $source -EntryType Information -EventId $eventId -Message $message

# Update user4's password
$secureNewPassword = ConvertTo-SecureString $newPassword -AsPlainText -Force
Set-LocalUser -Name "user4" -Password $secureNewPassword

# Output a confirmation message 
Write-Host "A new password for user4 has been logged in the Event Log."
