$domain_name = $args[0]
$password = $args[1]
$blob_name = $args[2]

$sa_password = $password

if (-not (Test-Path -Path C:\Maintenance)) { New-Item -Path "C:\" -Name "Maintenance" -ItemType "directory" }

# New-Item -ItemType Directory -Force -Path C:\Maintenance

Import-Module PowerShellGet

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# https://www.powershellgallery.com/packages/SqlServerDsc/14.3.0-preview0003

Install-Module -Name SqlServerDsc -AllowClobber -Force

# https://www.powershellgallery.com/packages/NetworkingDsc/8.2.0

Install-Module -Name NetworkingDsc -AllowClobber -Force

# configure SQL server
$file = "sql-config-dsc.ps1"
$url = "https://$($blob_name).blob.core.windows.net/scripts/$($file)"
$OutFile = "C:\Maintenance\$($file)"
$command = "powershell.exe -ExecutionPolicy Unrestricted -File C:\Maintenance\$($file)"
Invoke-WebRequest -Uri $Url -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Invoke-Expression -Command $command

$file = "sql-config-sql.ps1"
$url = "https://$($blob_name).blob.core.windows.net/scripts/$($file)"
$OutFile = "C:\Maintenance\$($file)"
$command = "powershell.exe -ExecutionPolicy Unrestricted -File C:\Maintenance\$($file) $($domain_name) $($password) $($sa_password)"
Invoke-WebRequest -Uri $Url -OutFile $OutFile -Verbose -ErrorAction SilentlyContinue
Invoke-Expression -Command $command