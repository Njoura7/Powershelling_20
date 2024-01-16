
Start-Sleep -s 12
# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel = 9
# Define the user for 'user9'
$userName9 = "user9"

# Define the file path
$filePath = "C:\ChallengeFile.txt"

# Generate random content for the file
$content = 1..400 | ForEach-Object { "Random Text " + (Get-Random -Maximum 10000) }

# Insert a unique identifier at a random line
$uniqueIdentifier = "SpecialEntryForLevel9"
$randomLineNumber = Get-Random -Minimum 1 -Maximum 400
$content[$randomLineNumber-1] = $uniqueIdentifier

# Create the file with the content
$content | Out-File -FilePath $filePath

$password9=$randomLineNumber.ToString()
$securePassword = ConvertTo-SecureString $password9 -AsPlainText -Force
Set-LocalUser -Name $userName9 -Password $securePassword

# Output the line number for script runner's reference (optional)
Write-Host "Unique identifier is in line: $randomLineNumber"
Write-Host "User $userName updated. Password is the line number: $randomLineNumber"


# Get Readme file 
$Readme = (Get-Content -Path "C:\Users\user8\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = 9 
    UserName = "user9"
    Password = $password9
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
