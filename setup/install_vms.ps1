# Download & install all files
#
# Wireshark
# Nmap
# Balens
# download Tails
# Chrome
# 
#
#
#
#
#
#


# Define the source and destination paths
$sourcePath = '\\instructor\share'
$destinationPath = 'D:'

# Get all zip files from the source directory
$zipFiles = Get-ChildItem -Path $sourcePath -Filter *.zip -Recurse -File

# Initialize progress variables
$totalFiles = $zipFiles.Count
$currentFileIndex = 0

# Extract each zip file to the destination directory
foreach ($file in $zipFiles) {
    # Update current file index
    $currentFileIndex++
    
    # Calculate the percentage completion
    $percentageComplete = ($currentFileIndex / $totalFiles) * 100

    # Show progress
    Write-Progress -Activity "Extracting files..." -Status "$currentFileIndex of $totalFiles" -PercentComplete $percentageComplete

    # Define the full path for the zip file at the destination
    $destinationZipPath = Join-Path -Path $destinationPath -ChildPath $file.Name

    # Copy the zip file to the destination
    Copy-Item -Path $file.FullName -Destination $destinationZipPath
    
    # Extract the zip file directly to the destination path
    Expand-Archive -Path $destinationZipPath -DestinationPath $destinationPath -Force

    # Optional: Remove the copied zip file after extraction if not needed
    # Remove-Item -Path $destinationZipPath

    Write-Output "Extracted: $destinationZipPath to $destinationPath"
}

# Final message
Write-Output "All zip files have been extracted to $destinationPath."
