# Turn off Windows Defender Firewall for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Output to confirm action
Write-Output "Windows Defender Firewall has been turned off for all profiles."
