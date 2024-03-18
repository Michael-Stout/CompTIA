# Define the source and destination paths
$sourcePath = '\\instructor\share'
$destinationPath = 'D:'

# Define path for "downloads" and "Virtual Machines" folders
$downloadsFolderPath = Join-Path -Path $destinationPath -ChildPath "downloads"
$vmFolderPath = Join-Path -Path $destinationPath -ChildPath "Virtual Machines"

# Create "downloads" and "Virtual Machines" folders if they do not exist
if (-not (Test-Path -Path $downloadsFolderPath)) {
    New-Item -ItemType Directory -Path $downloadsFolderPath
}
if (-not (Test-Path -Path $vmFolderPath)) {
    New-Item -ItemType Directory -Path $vmFolderPath
}

# Get all zip, exe, and iso files from the source directory
$files = Get-ChildItem -Path $sourcePath -Include *.zip, *.exe, *.iso -Recurse -File

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

    # Define the destination path for the file within the "downloads" folder
    $destinationFilePath = Join-Path -Path $downloadsFolderPath -ChildPath $file.Name

    # Copy the file to the "downloads" folder
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
Write-Output "All files have been processed. Zip files extracted to the Virtual Machines folder. Exe and Iso files copied to the downloads folder."
