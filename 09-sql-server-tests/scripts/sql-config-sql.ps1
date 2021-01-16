# $hostname = $args[0]

$domain_name = $args[0]

$domain_user = "devadmin"

$localadmin = ".\devadmin"

$localadminpassword = $args[1]

$saname = "sa_devadmin"

$sapassword = $args[2]

$ScriptBlock = {

    param([string]$domain_name, [string]$domain_user, [string]$saname, [string]$strtongsapassword)

    $Query = @"
IF SUSER_ID('$($domain_name)\$($domain_user)') IS NULL    
CREATE LOGIN [$($domain_name)\$($domain_user)] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
ALTER SERVER ROLE [sysadmin] ADD MEMBER [$($domain_name)\$($domain_user)]
GO
"@

    Invoke-Sqlcmd -Query $Query

    $Query = @"
IF SUSER_ID('$($saname)') IS NULL    
CREATE LOGIN [$($saname)] WITH PASSWORD=N'$($strtongsapassword)', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
ALTER SERVER ROLE [sysadmin] ADD MEMBER [$($saname)]
GO
"@

    Invoke-Sqlcmd -Query $Query
}

 

$pw = convertto-securestring -AsPlainText -Force -String $localadminpassword
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $localadmin, $pw
# $s = new-pssession -ComputerName $computer -Credential $cred
$s = new-pssession -Credential $cred

Invoke-Command -Session $s -ScriptBlock $ScriptBlock -ArgumentList $domain_name, $domain_user, $saname, $sapassword

Remove-PSSession -Session $s
