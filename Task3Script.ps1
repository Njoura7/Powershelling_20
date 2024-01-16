
#Start-Sleep -s 3

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"
# Specify the current task level
$taskLevel = 3

# Define the user for 'user3'
$userName3 = "user3"

# Define potential directories to hide the file
$directories = @(
    "C:\Windows\System32",
    "C:\Program Files",
    "C:\Users\Public",
    "C:\Windows",
    "C:\Temp"
)

# Remove existing 'supersecret.txt' files from these directories
foreach ($dir in $directories) {
    $existingFile = Join-Path -Path $dir -ChildPath "supersecret.txt"
    if (Test-Path -Path $existingFile) {
        Remove-Item -Path $existingFile
    }
}

# Randomly select a directory from the list
$selectedDirectory = Get-Random -InputObject $directories

# Ensure the selected directory exists
if (-not (Test-Path -Path $selectedDirectory)) {
    Write-Host "Selected directory does not exist."
    exit
}

# Create the file "supersecret.txt" in the selected directory
$filePath = Join-Path -Path $selectedDirectory -ChildPath "supersecret.txt"
"Password clue: The name of this directory is your key!" | Set-Content -Path $filePath

# Set user3's password to the name of the selected directory
# Extracting the last part of the path as the password
$password3 = Split-Path $selectedDirectory -Leaf
$securePassword3 = ConvertTo-SecureString $password3 -AsPlainText -Force

# Update the local user 'user3'
Set-LocalUser -Name $userName3 -Password $securePassword3

# Output the directory where the file is placed (for reference)
Write-Host "supersecret.txt is placed in: $selectedDirectory"


# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user2\Desktop\README.txt" -Raw).Trim()

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
    TaskLevel = 3 
    UserName = "user3"
    Password = $password3
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

