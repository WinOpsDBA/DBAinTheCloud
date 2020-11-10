# This is a script to execute in Azure PowerShell to get image details
# For more details please check Microsoft documentation https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage

$location  = "westeurope"
$publisher = "MicrosoftSQLServer"
$offer     = "sql2019-ws2019"

Get-AzVMImageSku -Location $location -PublisherName $publisher -Offer $offer | Select Skus

# $sku       = "SQLDEV"
# $version   = "latest"