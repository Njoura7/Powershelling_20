
#Start-Sleep -s 4
# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 4
# Define the user for 'user4'
$userName4 = "user4"

# Create a new event log source if it does not exist
$source = "SecretEventLogPswrd"
if (-not ([System.Diagnostics.EventLog]::SourceExists($source))) {
    [System.Diagnostics.EventLog]::CreateEventSource($source, "Application")
}



# Randomly generate a new password for user4
$password4 = -join ((65..90) + (97..122) | Get-Random -Count 6 | ForEach-Object {[char]$_})

# Write an event log entry with the new password
$eventId = 1  # Default Event ID
$message = "The new password for user4 is $password4"

Write-EventLog -LogName Application -Source $source -EntryType Information -EventId $eventId -Message $message

# Update user4's password with the new password
$secureNewPassword = ConvertTo-SecureString -String $password4 -AsPlainText -Force
Set-LocalUser -Name $userName4 -Password $secureNewPassword

# Output the last password for user4
Write-Host "The new password for user4 is: $password4"

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user3\Desktop\README.txt" -Raw).Trim()

# Function to check if credentials already exist in JSON file
function CredentialsExist($credentialsArray, $newCredentials) {
    foreach ($cred in $credentialsArray) {
        if ($cred.UserName -eq $newCredentials.UserName -and $cred.TaskLevel -eq $newCredentials.TaskLevel) {
            return $cred
        }
    }
    return $null
}



# Load existing credentials from JSON file
$existingCredentials = @()
if (Test-Path $credentialsFilePath) {
    $existingCredentials = Get-Content $credentialsFilePath | ConvertFrom-Json
}

# New credentials
$newCredentials = @{
    TaskLevel = 4 
    UserName = "user4"
    Password = $password4
    Readme = $Readme
}

# Check if credentials already exist
$existingCredential = CredentialsExist $existingCredentials $newCredentials

if ($existingCredential) {
    Write-Host "Credentials already exist. Updating password."
    # Update password if it has changed
    if ($existingCredential.Password -ne $newCredentials.Password) {
        $existingCredential.Password = $newCredentials.Password
        # Convert to JSON and save to file
        $existingCredentials | ConvertTo-Json | Set-Content -Path $credentialsFilePath
        Write-Host "Credentials updated in $credentialsFilePath."
    } else {
        Write-Host "Password unchanged. No update needed."
    }
} else {
    Write-Host "Adding new credentials."
    # Add new credentials
 $existingCredentials = @($existingCredentials) + @($newCredentials)



    # Convert to JSON and save to file
    $existingCredentials | ConvertTo-Json | Set-Content -Path $credentialsFilePath
    Write-Host "Credentials saved to $credentialsFilePath."
}


