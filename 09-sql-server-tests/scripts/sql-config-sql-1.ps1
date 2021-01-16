Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery"


$StringArray = "MYVAR1='String1'", "MYVAR2='String2'"
Invoke-Sqlcmd -Query "SELECT `$(MYVAR1) AS Var1, `$(MYVAR2) AS Var2" -Variable $StringArray

# Convert to a single set of credentials
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
 

PS C:> $sess = new-PSSession -computername (import-csv servers.csv) -credential domain01\admin01 -throttlelimit 16

PS C:> invoke-command -session $sess -scriptblock { get-process powershell } -AsJob

$s = New-PSSession -ComputerName Server02 -Credential Domain01\User01
Invoke-Command -Session $s -ScriptBlock { Get-Culture }


