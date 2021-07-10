Import-Module Pester -MinimumVersion 5.0.0

$path = "$($env:system_DefaultWorkingDirectory)\dm11\tests"

$config = [PesterConfiguration]::Default

$config.Output.Verbosity = 'Detailed'
$config.Run.Path = "$($path)\local-tests-after-build-sql.tests.ps1"
$config.Run.Exit = $true
$config.TestResult.Enabled = $true
$config.TestResult.OutputPath = "$($path)\testResults.xml"

Invoke-Pester -Configuration $config