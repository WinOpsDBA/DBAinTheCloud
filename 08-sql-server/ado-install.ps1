# https://sid-500.com/2017/07/01/powershell-how-to-install-a-domain-controller-with-server-core/
# http://www.itingredients.com/promote-domain-controller-with-windows-powershell/
# https://cloudblogs.microsoft.com/industry-blog/en-gb/cross-industry/2016/06/08/setting-up-active-directory-via-powershell/

# Invoke-WebRequest -Uri 'https://winopsdbadm5dcstorage1.blob.core.windows.net/scripts/dc-install.ps1' -OutFile 'c:\dc-install.ps1'

$hostname = $env:COMPUTERNAME

$service_password = $args[0]
$token = $args[1]

# Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Install-ADDSForest -DomainName winopsdba-demo7.local -InstallDNS -SafeModeAdministratorPassword (Convertto-SecureString -AsPlainText $password -Force) -Force

New-Item -Path "c:\maintenance" -ItemType Directory

Invoke-WebRequest -URI https://vstsagentpackage.azureedge.net/agent/2.171.1/vsts-agent-win-x64-2.171.1.zip -OutFile c:\maintenance\vsts-agent-win-x64-2.171.1.zip

Expand-Archive -Path c:\maintenance\vsts-agent-win-x64-2.171.1.zip -DestinationPath c:\maintenance\agent

# C:\maintenance\agent\config.cmd

# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops#unattended-config

# config
# --unattended
# --url https://dev.azure.com/myorganization
# --auth pat
# --token <token>
# --pool <pool>
# --agent <agent>
# --runAsService
# --runAsAutoLogon
# --windowsLogonAccount <account>
# --windowsLogonPassword <password>

$command = ".\config.cmd --unattended --pool dm8 --url https://dev.azure.com/WinOpsDBA --auth pat --token $($token) --agent $($hostname) --replace --runAsService --windowsLogonAccount 'winopsdba-demo8\ado_srv' --windowsLogonPassword '$($service_password)' --noRestart --acceptTeeEula"

Start-Process -FilePath "powershell" -WorkingDirectory "C:\maintenance\agent" -Verb RunAs -ArgumentList $command -Wait
