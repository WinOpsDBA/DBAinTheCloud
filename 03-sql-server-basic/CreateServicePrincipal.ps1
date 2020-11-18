$ServicePrincipalName = "winopsdba1-spn"

# create ServicePrincipal 
$sp = New-AzADServicePrincipal -DisplayName $ServicePrincipalName

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$ApplicationSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$SubscriptionId = (Get-AzSubscription).SubscriptionId
$TenantId = (Get-AzSubscription).TenantId
$ApplicationId = (Get-AzADServicePrincipal -displayname $ServicePrincipalName).ApplicationId.Guid

$sumary =@"
SubscriptionId:    $($SubscriptionId)
TenantId :         $($TenantId)
ApplicationId:     $($ApplicationId)
ApplicationSecret: $($ApplicationSecret)
"@

Write-Host $sumary