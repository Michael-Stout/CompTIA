# Turn off Windows Defender Firewall for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Output to confirm action
Write-Output "Windows Defender Firewall has been turned off for all profiles."

# Define the source and destination paths
$sourcePath = '\\instructor\share'
$destinationPath = 'D:'

# Define paths for "Class Downloads" and "Virtual Machines" folders
$classDownloadsFolderPath = Join-Path -Path $destinationPath -ChildPath "Class Downloads"
$vmFolderPath = Join-Path -Path $destinationPath -ChildPath "Virtual Machines"

# Create "Class Downloads" and "Virtual Machines" folders if they do not exist
if (-not (Test-Path -Path $classDownloadsFolderPath)) {
    New-Item -ItemType Directory -Path $classDownloadsFolderPath
}
if (-not (Test-Path -Path $vmFolderPath)) {
    New-Item -ItemType Directory -Path $vmFolderPath
}

# Get all files (not just .zip) from the source directory
$allFiles = Get-ChildItem -Path $sourcePath -Recurse -File

# Copy each file to the "Class Downloads" folder
foreach ($file in $allFiles) {
    $destinationPath = Join-Path -Path $classDownloadsFolderPath -ChildPath $file.Name
    Copy-Item -Path $file.FullName -Destination $destinationPath
    Write-Output "Copied: $file.Name to $classDownloadsFolderPath"
}

# Filter to get only zip files for extraction
$zipFiles = $allFiles | Where-Object { $_.Extension -eq '.zip' }

# Initialize progress variables for extraction
$totalZipFiles = $zipFiles.Count
$currentZipFileIndex = 0

# Extract each zip file
foreach ($zipFile in $zipFiles) {
    # Update current file index for extraction
    $currentZipFileIndex++

    # Calculate the percentage completion for extraction
    $percentageComplete = ($currentZipFileIndex / $totalZipFiles) * 100

    # Show progress for extraction
    Write-Progress -Activity "Extracting .zip files..." -Status "$currentZipFileIndex of $totalZipFiles" -PercentComplete $percentageComplete

    # Define the destination path for the zip file within the "Class Downloads" folder
    $destinationZipPath = Join-Path -Path $classDownloadsFolderPath -ChildPath $zipFile.Name

    # Define the extraction path within the "Virtual Machines" folder, maintaining the zip file's name without extension
    $extractionPath = Join-Path -Path $vmFolderPath -ChildPath $zipFile.BaseName

    # Extract the zip file to the designated "Virtual Machines" folder path
    Expand-Archive -Path $destinationZipPath -DestinationPath $extractionPath -Force

    Write-Output "Extracted: $zipFile.Name to $extractionPath"
}

# Final message
Write-Output "All files have been copied to the Class Downloads folder. All zip files have been extracted to the Virtual Machines folder."
