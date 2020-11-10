# $hostname = $args[0]

$localadmin = ".\devadmin"

$localadminpassword = $args[0]

$saname = "sa_devadmin"

$sapassword = $args[1]

$ScriptBlock = {

param([string]$saname, [string]$strtongsapassword)

$Query = @"
IF SUSER_ID('winopsdba-demo8\devadmin') IS NULL    
CREATE LOGIN [winopsdba-demo8\devadmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
ALTER SERVER ROLE [sysadmin] ADD MEMBER [winopsdba-demo8\devadmin]
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

Invoke-Command -Session $s -ScriptBlock $ScriptBlock -ArgumentList $saname, $sapassword

Remove-PSSession -Session $s
