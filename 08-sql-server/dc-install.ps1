# https://sid-500.com/2017/07/01/powershell-how-to-install-a-domain-controller-with-server-core/
# http://www.itingredients.com/promote-domain-controller-with-windows-powershell/
# https://cloudblogs.microsoft.com/industry-blog/en-gb/cross-industry/2016/06/08/setting-up-active-directory-via-powershell/

# Invoke-WebRequest -Uri 'https://winopsdbadm5dcstorage1.blob.core.windows.net/scripts/dc-install.ps1' -OutFile 'c:\dc-install.ps1'

$password = $args[0]
$ado_password = $args[1]

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -DomainName winopsdba-demo8.local -InstallDNS -SafeModeAdministratorPassword (Convertto-SecureString -AsPlainText $password -Force) -Force

# add user to run service

New-ADUser ado_srv -AccountPassword (ConvertTo-SecureString $ado_password -AsPlainText -force) -PasswordNeverExpires $true -Enabled $true -passThru 

