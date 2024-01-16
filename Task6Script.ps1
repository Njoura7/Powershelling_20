#Start-Sleep -s 7

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 6
# Define the user for 'user6'
$userName6 = "user6" 

# Retrieve the current DNS server addresses for IPv4
$dnsInfo = Get-DnsClientServerAddress -AddressFamily IPv4
$dnsAddresses = $dnsInfo.ServerAddresses

# Check if the result is an array or a single value
if ($dnsAddresses -is [array] -and $dnsAddresses.Count -gt 0) {
    $dnsAddress = $dnsAddresses[0]
} elseif ($dnsAddresses) {
    $dnsAddress = $dnsAddresses
} else {
    $dnsAddress = "NoDNSFound"
    Write-Host "No DNS Server address found. Defaulting password to 'NoDNSFound'."
}

$password6=$dnsAddress

# Convert the DNS address to a secure string for the password
$securePassword6 = ConvertTo-SecureString $password6 -AsPlainText -Force

# Update the new local user 'user6' with the DNS address as the password
Set-LocalUser -Name $userName6 -Password $securePassword6

# Confirmation message
Write-Host "User6 updated. Password is set to the current DNS Server address: $dnsAddress"


# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user5\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = 6 
    UserName = "user6"
    Password = $password6
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

