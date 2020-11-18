# create resource group

$rg_name = "d1-storage-rg"
$location = "westeurope"
$storage_name = "winopsdbaweudemo1storage"
$containerName = "backendconfig"

New-AzResourceGroup -Name $rg_name -Location $location

# create storage account

$storageAccount = New-AzStorageAccount -ResourceGroupName $rg_name `
  -Name $storage_name `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind StorageV2

$ctx = $storageAccount.Context

New-AzStorageContainer -Name $containerName -Context $ctx -Permission off

# generate remove command

write-host ("Remove-AzStorageAccount -Name $($storage_name) -ResourceGroupName $($rg_name)")

# Remove-AzStorageAccount -Name winopsdbaweudemo1storage -ResourceGroupName d1-storage-rg