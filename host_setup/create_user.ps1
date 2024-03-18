# Create the new local user
$userName = "user"
$password = ConvertTo-SecureString "Pa$$w0rd" -AsPlainText -Force
New-LocalUser -Name $userName -Password $password -Description "Local user account"

# Add the user to the Administrators group
$group = "Administrators"
Add-LocalGroupMember -Group $group -Member $userName

# Output to confirm actions
Write-Output "User '$userName' created and added to the '$group' group."
