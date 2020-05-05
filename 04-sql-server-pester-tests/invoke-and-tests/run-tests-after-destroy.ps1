$path = "$($env:system_DefaultWorkingDirectory)\tests\invoke-and-tests\"

Invoke-Pester -OutputFile "$($path)\tests-after-destroy-results.xml" `
-OutputFormat 'NUnitXml' `
-Script "$($path)\tests-after-destroy.tests.ps1"
