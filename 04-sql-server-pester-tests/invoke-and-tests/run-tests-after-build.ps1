$path = "$($env:system_DefaultWorkingDirectory)\tests\invoke-and-tests\"

Invoke-Pester -OutputFile "$($path)\tests-after-build-results.xml" `
-OutputFormat 'NUnitXml' `
-Script "$($path)\tests-after-build.tests.ps1"

Invoke-Pester -OutputFile "$($path)\tests-connectivity-from-internet.xml" `
-OutputFormat 'NUnitXml' `
-Script "$($path)\test-connectivity-from-internet.tests.ps1"
