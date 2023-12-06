# Define the user for 'user7'
$userName7 = "user7"

# Get network adapters statistics
$adaptersStats = Get-NetAdapterStatistics

# Find the adapter with the highest 'ReceivedBytes'
$adapterWithMostData = $adaptersStats | Sort-Object -Property ReceivedBytes -Descending | Select-Object -First 1
$adapterName = $adapterWithMostData.Name

# Handle cases where no adapter is found
if (-not $adapterName) {
    $adapterName = "NoAdapterFound"
    Write-Host "No network adapter found. Defaulting password to 'NoAdapterFound'."
}

# Convert the adapter name to a secure string for the password
$securePassword7 = ConvertTo-SecureString $adapterName -AsPlainText -Force

# Create the new local user 'user7' with the adapter name as the password
New-LocalUser -Name $userName7 -Password $securePassword7

# Confirmation message
Write-Host "User7 created. Password is set to the name of the network adapter with the highest 'ReceivedBytes'."
