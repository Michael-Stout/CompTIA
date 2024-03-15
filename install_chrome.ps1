# Path to the MSI file
$chromeInstallerPath = "C:\Path\To\GoogleChromeStandaloneEnterprise.msi"
# Installation command
$installCommand = "msiexec /i `"$chromeInstallerPath`" /quiet /norestart"
Invoke-Expression -Command $installCommand

# Optionally, set the default homepage by modifying the registry or deploying a master_preferences file
# For example, setting the homepage via the registry (adjust the path as necessary)
$regPath = "HKLM:\Software\Policies\Google\Chrome"
$homePage = "http://www.example.com"
New-Item -Path $regPath -Force
New-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -PropertyType DWord -Force
New-ItemProperty -Path $regPath -Name "RestoreOnStartupURLs" -Value $homePage -PropertyType MultiString -Force
