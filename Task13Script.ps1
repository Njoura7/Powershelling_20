#Start-Sleep -s 16

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel13 = 13

# Define the user for 'user13'
$userName13 = "user13"


# Step 1: Create user13 (created)
#New-LocalUser -Name $userName13 -Password (ConvertTo-SecureString -String "TempPassword123" -AsPlainText -Force)

# Step 2: Find the process with the highest CPU usage
$highestCpuProcess = Get-Process | Sort-Object CPU -Descending | Select-Object -First 1

# Step 3: Assign the PID as the password for user12
$password13 = $highestCpuProcess.Id
$securePassword = (ConvertTo-SecureString -String $password13 -AsPlainText -Force)
Set-LocalUser -Name $username13 -Password $securePassword

# Step 4: Display information
Write-Host "Process with the highest CPU usage:"
$highestCpuProcess | Format-Table -Property Id, ProcessName, CPU -AutoSize
Write-Host "Password for user13 set successfully. PID: $password13"


# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user12\Desktop\README.txt" -Raw).Trim()
 
 
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
    TaskLevel = 13 
    UserName = "user13"
    Password = $password13
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

