#Start-Sleep -s 21

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 18

# Define the user for 'user18'
$userName18 = "user18"

# Retrieve a specific environment variable and set it as the password
$password18 = [Environment]::GetEnvironmentVariable("SystemDrive")

# Convert the password to a secure string
$securePassword18 = ConvertTo-SecureString $password18 -AsPlainText -Force

# Create the new local user 'user18'
Set-LocalUser -Name $userName18 -Password $securePassword18

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user17\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = $taskLevel 
    UserName = $userName18
    Password = $password18
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
