#Start-Sleep -s 17

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel14 = 14

# Define the user for 'user11'
$userName14 = "user14"


# Processes to exclude from consideration
$excludedProcesses = @("Idle", "System", "svchost", "lsass", "csrss" )

# Get the application with the least memory usage (excluding specified processes)
$leastMemoryApp = Get-Process | Where-Object { $_.ProcessName -notin $excludedProcesses } | Sort-Object WorkingSet -Descending | Select-Object -Last 1

# Set the password for 'user14' based on the name of the application
$password14 = $leastMemoryApp.ProcessName


# Set the password for 'user14'
$securePassword = (ConvertTo-SecureString -String $password14 -AsPlainText -Force)
Set-LocalUser -Name $userName14 -Password $securePassword

# Display the password for 'user14'
Write-Host "Password for user14 set successfully. Password: $password14"

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user13\Desktop\README.txt" -Raw).Trim()
 
 
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
    TaskLevel = 14 
    UserName = "user14"
    Password = $password14
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

