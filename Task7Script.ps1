#Start-Sleep -s 8

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 7
# Define the user for 'user7'
$userName7 = "user7"

# Get network adapters statistics
$adaptersStats = Get-NetAdapterStatistics

# Find the adapter with the highest 'ReceivedBytes'
$adapterWithMostData = $adaptersStats | Sort-Object -Property ReceivedBytes -Descending | Select-Object -First 1
$adapterName = $adapterWithMostData.Name

# Handle cases where no adapter is found
if (-not $adapterName) {
    $adapterName = "NoAdapterFound"
    Write-Host "No network adapter found. Defaulting password to 'NoAdapterFound'."
}

$password7=$adapterName

# Convert the adapter name to a secure string for the password
$securePassword7 = ConvertTo-SecureString $password7 -AsPlainText -Force

# Create the new local user 'user7' with the adapter name as the password
Set-LocalUser -Name $userName7 -Password $securePassword7

# Confirmation message
Write-Host "User7 created. Password is set to the name of the network adapter with the highest 'ReceivedBytes': $password7"

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user6\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = 7 
    UserName = "user7"
    Password = $password7
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

