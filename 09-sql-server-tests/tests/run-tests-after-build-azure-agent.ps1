Import-Module Pester -MinimumVersion 5.0.0

$path = "$($env:system_DefaultWorkingDirectory)\dm9\tests"

$config = [PesterConfiguration]::Default

$config.Output.Verbosity = 'Detailed'
$config.Run.Path = "$($path)\azure-tests-after-build*.tests.ps1"
$config.TestResult.Enabled = $true
$config.TestResult.OutputPath = "$($path)\testResults.xml"

Invoke-Pester -Configuration $config