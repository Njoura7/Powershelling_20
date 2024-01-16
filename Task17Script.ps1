#Start-Sleep -s 20
# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 17

# Define the user for 'user1'
$userName17 = "user17"


# Specify the Lichess API endpoint for user information
$apiEndpoint = "https://lichess.org/api/user/{username}"

# Specify the Lichess username you want to check
$username = "njoura"

# Create the API URL by replacing {username} with the actual username
$apiUrl = $apiEndpoint -replace "{username}", $username

try {
    # Make a GET request to the Lichess API
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get

    # Extract the rating from the API response
    $rating = $response.perfs.blitz.rating

    # Output the rating
    Write-Host "The rating of user '$username' is: $rating"
}
catch {
    # Handle any errors that may occur during the API request
    Write-Host "Error fetching data from the Lichess API: $_"
}

if ($rating -eq $null) {
    $password17 = 950
} else {
    $password17 = $rating
}

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $password17 -AsPlainText -Force

# Create the new local user 'user17'
Set-LocalUser -Name $userName17 -Password $securePassword

# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user16\Desktop\README.txt" -Raw).Trim()
 
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
    TaskLevel = 17 
    UserName = "user17"
    Password = $password17
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
