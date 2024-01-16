#Start-Sleep -s 14

# Specify the path to the credentials file
$credentialsFilePath = "C:\Powershelling_20_WebApp\Credentials.json"

# Specify the current task level
$taskLevel11 = 11

# Define the user for 'user11'
$userName11 = "user11"


$buggyScript1 = @'
$number = 25
Write-Output "Square root: $([Math]::Sqrt(number))"  # Intentional syntax error
'@

# Corrected Buggy Script 1
$correctedScript1 = @'
$number = 25
Write-Output "Square root: $([Math]::Sqrt($number))"  # Corrected line: Added '$' before 'number'
'@

# Buggy Script 2
$buggyScript2 = @'
$variable = 5
Write-Output "Value: $($variab)"  # Intentional typo
'@

# Corrected Buggy Script 2
$correctedScript2 = @'
$variable = 5
Write-Output "Value: $($variable)"  # Corrected line: Added 'le' in the variable name
'@

# Buggy Script 3
$buggyScript3 = @'
$number1 = 10
$number2 = 5
$result = $number1 + $number2  # Intentional mistake
Write-Output "Result: $result"  # Incorrect output message
'@

# Corrected Buggy Script 3
$correctedScript3 = @'
$number1 = 10
$number2 = 5
$result = $number1 / $number2  # Intentional mistake: addition instead of division
Write-Output "Result: $result"  # Incorrect output message
'@

# List of buggy scripts
$buggyScripts = $buggyScript1, $buggyScript2, $buggyScript3

# List of corrected scripts
$correctedScripts = $correctedScript1, $correctedScript2, $correctedScript3

# Randomly choose a buggy script
$chosenScriptIndex = Get-Random -Minimum 0 -Maximum $buggyScripts.Count
$chosenScript = $buggyScripts[$chosenScriptIndex]

# Get the corresponding corrected script
$correctedScript = $correctedScripts[$chosenScriptIndex]

# Create the buggy script file on the desktop
$buggyScriptPath = "C:\Users\user10\Desktop\BuggyScript.ps1"
$chosenScript | Out-File -FilePath $buggyScriptPath -Encoding UTF8

# Execute the chosen script
$password = Invoke-Expression $correctedScript

# Update the user10 password
$password11 = $password.Trim()

Write-Output "User11 password: $password11"



$securePassword = (ConvertTo-SecureString -String $password11 -AsPlainText -Force)
Set-LocalUser -Name $userName11 -Password $securePassword



# Get Readme file
$Readme = (Get-Content -Path "C:\Users\user10\Desktop\README.txt" -Raw).Trim()
 
 
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
    TaskLevel = 11 
    UserName = "user11"
    Password = $password11
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

