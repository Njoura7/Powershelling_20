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

# Convert the DNS address to a secure string for the password
$securePassword6 = ConvertTo-SecureString $dnsAddress -AsPlainText -Force

# Update the new local user 'user6' with the DNS address as the password
Set-LocalUser -Name $userName6 -Password $securePassword6

# Confirmation message
Write-Host "User6 updated. Password is set to the current DNS Server address."
