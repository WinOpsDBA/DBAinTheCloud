$path = "$($env:system_DefaultWorkingDirectory)\dm11\tests"

$p = Invoke-Pester "$($path)\tests-after-build.tests.ps1" -Passthru
$p | Export-NUnitReport -Path "$($path)\tests-after-build-results.xml"

$p = Invoke-Pester "$($path)\test-connectivity-from-internet.tests.ps1" -Passthru
$p | Export-NUnitReport -Path "$($path)\tests-connectivity-from-internet.xml"
