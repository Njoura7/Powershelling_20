# Define the user for 'user3'
$userName3 = "user3"

# Define potential directories to hide the file
$directories = @(
    "C:\Windows\System32",
    "C:\Program Files",
    "C:\Program Files (x86)",
    "C:\Users\Public",
    "C:\Windows",
    "C:\Temp",
    "C:\Windows\Temp",
    "C:\Windows\Logs"
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
$directoryName = Split-Path $selectedDirectory -Leaf
$securePassword3 = ConvertTo-SecureString $directoryName -AsPlainText -Force

# Update the local user 'user3'
Set-LocalUser -Name $userName3 -Password $securePassword3

# Output the directory where the file is placed (for reference)
Write-Host "supersecret.txt is placed in: $selectedDirectory"
