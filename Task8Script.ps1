
Start-Sleep -s 11
# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 8
# Define the user for 'user8'
$userName8 = "user8"

# Delete the previous generated IP
Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object { $_.IPAddress -like '10.*' } | 
    ForEach-Object { Remove-NetIPAddress -IPAddress $_.IPAddress -Confirm:$false }

# Function to generate a unique IP address within a specific range
Function Generate-UniqueIPAddress {
    $octet1 = 10
    $octet2 = Get-Random -Minimum 0 -Maximum 255
    $octet3 = Get-Random -Minimum 0 -Maximum 255
    $octet4 = Get-Random -Minimum 2 -Maximum 254
    return "$octet1.$octet2.$octet3.$octet4"
}

# Generate a unique IP address
$ipAddress = Generate-UniqueIPAddress

# Select a network adapter to configure
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

# Assign the unique IP address to the adapter
$interfaceAlias = $adapter.InterfaceAlias
New-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $ipAddress -PrefixLength 24 -AddressFamily IPv4

$password8=$ipAddress

$securePassword = ConvertTo-SecureString $password8 -AsPlainText -Force
Set-LocalUser -Name $userName8 -Password $securePassword

# Output for script runner's reference (optional)
Write-Host "Unique IP set for $interfaceAlias : $ipAddress"
Write-Host "User $userName created. Password is the full IP address: $ipAddress"

# Get Readme file 
$Readme = (Get-Content -Path "C:\Users\user7\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = 8 
    UserName = "user8"
    Password = $password8
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
