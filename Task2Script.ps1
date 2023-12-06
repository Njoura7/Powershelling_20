# Define the user for 'user2'
$userName2 = "user2"

# Get the current PowerShell version and set it as the password
$psVersion = $PSVersionTable.PSVersion.Major
$password2 = "Version$psVersion"

# Convert the password to a secure string
$securePassword2 = ConvertTo-SecureString $password2 -AsPlainText -Force

# Create the new local user 'user2'
New-LocalUser -Name $userName2 -Password $securePassword2


