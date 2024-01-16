# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 20

# Define the user for 'user20'
$userName20 = "user20"

# Get the SID of 'user19'
$sidUser19 = ((Get-LocalUser -Name user19).SID).Value



# Create a password for 'user20' using the SID
$password20 = $sidUser19

# Convert the password to a secure string
$securePassword20 = ConvertTo-SecureString $password20 -AsPlainText -Force

# Create the new local user 'user20'
# Note: Ensure the password meets domain requirements
try {
    Set-LocalUser -Name $userName20 -Password $securePassword20 -ErrorAction Stop
    Write-Host "User '$userName20' created successfully."
}
catch {
    Write-Host "Error creating user '$userName20': $_"
}

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user19\Desktop\README.txt" -Raw).Trim()
# Function to check if credentials already exist in JSON file
function CredentialsExist($credentialsArray, $newCredentials) {
    foreach ($cred in $credentialsArray) {
        if ($cred.UserName -eq $newCredentials.UserName -and $cred.TaskLevel -eq $newCredentials.TaskLevel) {
            return $cred
        }
    }
    return $null
}
# Save credentials locally
$credentials = @{
    TaskLevel = $taskLevel
    UserName = $userName20
    Password = $password20.Trim()
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
