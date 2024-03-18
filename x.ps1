# Define the source and destination paths
$sourcePath = '\\instructor\share'
$destinationPath = 'D:'

# Define path for "Class Downloads" and "Virtual Machines" folders
$classDownloadsFolderPath = Join-Path -Path $destinationPath -ChildPath "Class Downloads"
$vmFolderPath = Join-Path -Path $destinationPath -ChildPath "Virtual Machines"

# Create "Class Downloads" and "Virtual Machines" folders if they do not exist
if (-not (Test-Path -Path $classDownloadsFolderPath)) {
    New-Item -ItemType Directory -Path $classDownloadsFolderPath
}
if (-not (Test-Path -Path $vmFolderPath)) {
    New-Item -ItemType Directory -Path $vmFolderPath
}

# Get all files from the source directory
$files = Get-ChildItem -Path $sourcePath -Recurse -File

# Initialize progress variables
$totalFiles = $files.Count
$currentFileIndex = 0

# Process each file
foreach ($file in $files) {
    # Update current file index
    $currentFileIndex++
    
    # Calculate the percentage completion
    $percentageComplete = ($currentFileIndex / $totalFiles) * 100

    # Show progress
    Write-Progress -Activity "Processing files..." -Status "$currentFileIndex of $totalFiles" -PercentComplete $percentageComplete

    # Define the destination path for the file within the "Class Downloads" folder
    $destinationFilePath = Join-Path -Path $classDownloadsFolderPath -ChildPath $file.Name

    # Copy the file to the "Class Downloads" folder
    Copy-Item -Path $file.FullName -Destination $destinationFilePath

    # If the file is a zip file, extract it to the "Virtual Machines" folder
    if ($file.Extension -eq ".zip") {
        # Define the extraction path within the "Virtual Machines" folder, maintaining the zip file's name without extension
        $extractionPath = Join-Path -Path $vmFolderPath -ChildPath $file.BaseName

        # Extract the zip file to the designated "Virtual Machines" folder path
        Expand-Archive -Path $destinationFilePath -DestinationPath $extractionPath -Force

        Write-Output "Extracted: $file.Name to $extractionPath"
    }
}

# Final message
Write-Output "All files have been processed. Zip files extracted to the Virtual Machines folder. Other files copied to the Class Downloads folder."
