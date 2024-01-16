#Start-Sleep -s 15

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel12 = 12

# Define the user for 'user12'
$userName12 = "user12"

# Specify the path to the file on the desktop of user11
$filePath = "C:\Users\user11\Desktop\checkMyPermissions.txt"

# Create the file if it doesn't exist
if (-not (Test-Path $filePath)) {
    New-Item -ItemType File -Path $filePath | Out-Null
}

# Define a list of possible permissions
$permissions = @("Write", "FullControl", "Modify", "ReadAndExecute")

# Set random permission from the list
$randomPermission = Get-Random -InputObject $permissions

# Set the password for user11 based on the updated permission
$password12 = $randomPermission

# Apply the updated permission to the file for user11
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:COMPUTERNAME\user11", $randomPermission, "Allow")
$acl = Get-Acl -Path $filePath
$acl.SetAccessRule($rule)
Set-Acl -Path $filePath -AclObject $acl

# Display the permission for user11 on checkMyPermissions.txt
$actualPermission = (Get-Acl $filePath).Access | Where-Object { $_.IdentityReference -eq "$env:COMPUTERNAME\user11" }
$actualPermissionString = $actualPermission.FileSystemRights -join ", "

Write-Host "New permission for checkMyPermissions.txt: $password12"
Write-Host "New password for user12 set successfully."

# Update the password for user12 based on the permission applied to user11
Set-LocalUser -Name "user12" -Password (ConvertTo-SecureString -String $password12 -AsPlainText -Force)



# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user11\Desktop\README.txt" -Raw).Trim()
 
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
    TaskLevel = 12 
    UserName = "user12"
    Password = $password12
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

