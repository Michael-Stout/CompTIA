# Define the source and destination paths
$sourcePath = '\\instructor\share'
$destinationPath = 'D:'

# Define paths for "Zips" and "Virtual Machines" folders
$zipsFolderPath = Join-Path -Path $destinationPath -ChildPath "Zips"
$vmFolderPath = Join-Path -Path $destinationPath -ChildPath "Virtual Machines"

# Create "Zips" and "Virtual Machines" folders if they do not exist
if (-not (Test-Path -Path $zipsFolderPath)) {
    New-Item -ItemType Directory -Path $zipsFolderPath
}
if (-not (Test-Path -Path $vmFolderPath)) {
    New-Item -ItemType Directory -Path $vmFolderPath
}

# Get all zip files from the source directory
$zipFiles = Get-ChildItem -Path $sourcePath -Filter *.zip -Recurse -File

# Initialize progress variables
$totalFiles = $zipFiles.Count
$currentFileIndex = 0

# Process each zip file
foreach ($file in $zipFiles) {
    # Update current file index
    $currentFileIndex++
    
    # Calculate the percentage completion
    $percentageComplete = ($currentFileIndex / $totalFiles) * 100

    # Show progress
    Write-Progress -Activity "Processing files..." -Status "$currentFileIndex of $totalFiles" -PercentComplete $percentageComplete

    # Define the destination path for the zip file within the "Zips" folder
    $destinationZipPath = Join-Path -Path $zipsFolderPath -ChildPath $file.Name

    # Copy the zip file to the "Zips" folder
    Copy-Item -Path $file.FullName -Destination $destinationZipPath

    # Define the extraction path within the "Virtual Machines" folder, maintaining the zip file's name without extension
    $extractionPath = Join-Path -Path $vmFolderPath -ChildPath $file.BaseName

    # Extract the zip file to the designated "Virtual Machines" folder path
    Expand-Archive -Path $destinationZipPath -DestinationPath $extractionPath -Force

    Write-Output "Extracted: $file.Name to $extractionPath"
}

# Final message
Write-Output "All zip files have been processed and extracted to the Virtual Machines folder."
