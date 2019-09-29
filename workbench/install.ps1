
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

New-Item -Path 'C:\Maintenance' -ItemType Directory

$Uri = "https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_windows_amd64.zip"
$OutFile = "C:\\Maintenance\\terraform_0.12.8_windows_amd64.zip"
$OutPath = "C:\\terraform\\"

Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Unblock-File -Path $OutFile -ErrorAction SilentlyContinue
Expand-Archive $OutFile -DestinationPath $OutPath -ErrorAction SilentlyContinue

$Uri = "https://releases.hashicorp.com/terraform-provider-azurerm/1.33.1/terraform-provider-azurerm_1.33.1_windows_amd64.zip"
$OutFile = "C:\\Maintenance\\terraform-provider-azurerm_1.33.1_windows_amd64.zip"
$OutPath = "C:\\terraform\\plugin\\"

Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Unblock-File -Path $OutFile -ErrorAction SilentlyContinue
Expand-Archive $OutFile -DestinationPath $OutPath -ErrorAction SilentlyContinue

$Uri = "https://aka.ms/win32-x64-user-stable"
#$Uri = "https://update.code.visualstudio.com/1.38.1/win32-x64-user/stable/VSCodeUserSetup-x64-1.38.1.exe"
$OutFile = "C:\\Maintenance\\VSCodeUserSetup.exe"

Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Unblock-File -Path $OutFile -ErrorAction SilentlyContinue

Start-Process -FilePath "C:\Maintenance\VSCodeUserSetup.exe" -Argument "/VERYSILENT /MERGETASKS=!runcode"

$Uri = "https://aka.ms/installazurecliwindows/azure-cli-2.0.73.msi"
$OutFile = "C:\\Maintenance\azure-cli-2.0.73.msi"

# Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
# Unblock-File -Path $OutFile -ErrorAction SilentlyContinue

# Start-Process -FilePath "C:\Maintenance\azure-cli-2.0.73.msi" -Argument "/quiet"

Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

$Uri = "https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe"
$OutFile = "C:\\Maintenance\Git-2.23.0-64-bit.exe"

Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Unblock-File -Path $OutFile -ErrorAction SilentlyContinue

Start-Process -FilePath "C:\Maintenance\Git-2.23.0-64-bit.exe" -Argument " /VERYSILENT /NORESTART /NOCANCEL"

$Uri = "https://github.com/ckaiser/Lightscreen/releases/download/v2.4/LightscreenSetup-2.4.exe"
$OutFile = "C:\\Maintenance\LightscreenSetup-2.4.exe"

Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Unblock-File -Path $OutFile -ErrorAction SilentlyContinue

Start-Process -FilePath "C:\Maintenance\LightscreenSetup-2.4.exe" -Argument "/VERYSILENT"


# $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

# git clone ? ? ?
# Start-Process -FilePath "C:\Program Files\Git\bin\git" -WorkingDirectory "C:\" -ArgumentList "clone https://github.com/WinOpsDBA/DBAinTheCloud.git" 
