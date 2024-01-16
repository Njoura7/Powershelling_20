
#Start-Sleep -s 5

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 5
# Define the user for 'user5'
$userName5 = "user5" 

# Define the registry path and the password
$registryPath = "HKCU:\Software\Task5Challenge"
$registryProperty = "Password"
$password5 = "RegPassword123" # Predetermined password

# Create the registry key with the password
New-Item -Path $registryPath -Force | Out-Null
New-ItemProperty -Path $registryPath -Name $registryProperty -Value $password5 -PropertyType String | Out-Null

# Convert the password to a secure string
$securePassword5 = ConvertTo-SecureString $password5 -AsPlainText -Force

# Create the new local user 'user5' with the password from the registry
Set-LocalUser -Name $userName5 -Password $securePassword5

# Confirmation message   
Write-Host "User5 updated ($password5). Password is stored in the registry at $registryPath."

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user4\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = 5 
    UserName = "user5"
    Password = $password5
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


