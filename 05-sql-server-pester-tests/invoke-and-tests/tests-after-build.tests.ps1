$rg_name = "A-D1-DM3-RG"
$nsg_name = "A-D1-DM3-nsg"
$allowed_public_IP = "?.?.?.?"
$server_names = ("a-d1-dm3-sql1")
$server_size = "Standard_DS2_v2"
$server_count = $server_names.count

describe 'Azure congifuration test' {

    context "Check if recource group exist" {

        $rg_exist = ((Get-AzResourceGroup | where { $_.ResourceGroupName -eq $rg_name }).count -eq 1)

        it "Resource group ($($rg_name)) exist" {
            $rg_exist | should be $true
        }
    }

    context "Check NSG rules - if allow access from home IP exist" {

        $NSG = Get-AzNetworkSecurityGroup -name $nsg_name -ResourceGroupName $rg_name

        $access = ($NSG.SecurityRules | where-object { ($_.Direction -eq "Inbound") -and ($_.SourceAddressPrefix -contains $allowed_public_IP) -and ($_.DestinationPortRange -contains "3389") }).access

        It "$($NSG.name) allows access from $($allowed_public_IP)" {
            $access | Should Be 'Allow'
        }
    }

    context "Server(s) check" {

        foreach ($server in $server_names) {

            # check if server exist
            $server_exist = (Get-AzVM | where { ($_.ResourceGroupName -eq $rg_name) -and ($_.Name -eq $server) }).count

            it "Server $($server) does exist" {
                $server_exist | should be 1
            }
            
            # check size
            $server_size_test = (Get-AzVM -ResourceGroupName $rg_name -Name $server).HardwareProfile.VmSize

            it "Server $($server) size is $($server_size)" {
                $server_size_test | should be $server_size
            }

        }
    }

    context "Server(s) count check" {
        
        # check server count in RG
        $server_counts_test = (Get-AzVM -ResourceGroupName $rg_name).count

        it "Server(s) count is $($server_count)" {
            $server_counts_test | should be $server_count
        }
    }
}
