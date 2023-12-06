# Define the user for 'user5'
$userName5 = "user5" 

# Define the registry path and the password
$registryPath = "HKCU:\Software\Task5Challenge"
$registryProperty = "Password"
$registryPassword = "RegPassword123" # Predetermined password

# Create the registry key with the password
New-Item -Path $registryPath -Force | Out-Null
New-ItemProperty -Path $registryPath -Name $registryProperty -Value $registryPassword -PropertyType String | Out-Null

# Convert the password to a secure string
$securePassword5 = ConvertTo-SecureString $registryPassword -AsPlainText -Force

# Create the new local user 'user5' with the password from the registry
Set-LocalUser -Name $userName5 -Password $securePassword5

# Confirmation message   
Write-Host "User5 updated. Password is stored in the registry at $registryPath."
