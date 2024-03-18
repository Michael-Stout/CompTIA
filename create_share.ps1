# Define the folder name and path directly on the F drive
$folderName = "Share"
$folderPath = "F:\$folderName" # This line is modified to point to the F drive

# Create the folder if it doesn't already exist
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

# Import the necessary module for sharing the folder
Import-Module SmbShare

# Current user's username
$currentUsername = $env:USERNAME

# Share the folder, granting full control to the current user and read-only to everyone
New-SmbShare -Name $folderName -Path $folderPath -FullAccess $currentUsername -ReadAccess "Everyone"

# Now set NTFS permissions
$acl = Get-Acl $folderPath

# Grant full control to the current user
$user = [System.Security.Principal.NTAccount]::new($currentUsername)
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($accessRule)

# Grant Read-Only access to Everyone
$everyone = New-Object System.Security.Principal.SecurityIdentifier("S-1-1-0")
$everyoneAccount = $everyone.Translate([System.Security.Principal.NTAccount])
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($everyoneAccount, "Read", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($accessRule)

# Apply the NTFS permissions to the folder
Set-Acl -Path $folderPath -AclObject $acl

Write-Host "Folder '$folderName' has been created and shared on the F drive with specified permissions."
