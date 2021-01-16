BeforeAll {
    $rg_name = "a-d1-dm9-rg"
    $nsg_name = "a-d1-dm9-nsg"
    $allowed_public_IP = "x.x.x.x"
    $server_count = 3
}

$servers = @(
    @{ name = 'a-d1-dm9-dc1'; size = 'Standard_B1ms' }
    @{ name = 'a-d1-dm9-ado1'; size = 'Standard_B1ms' }
    @{ name = 'a-d1-dm9-sql1'; size = 'Standard_E2as_v4' }
)

describe 'Azure_congifuration' {

    context "Check if recource group exist" {

        it "Resource group <rg_name> exist" {

            $rg_exist = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -eq $rg_name }).count

            $rg_exist | should -Be 1
        }
    }

    context "Check NSG rules - if allow access from home IP" {

        It "<nsg_name> allows access from <allowed_public_IP>" {

            $NSG = Get-AzNetworkSecurityGroup -name $nsg_name -ResourceGroupName $rg_name
        
            $access = ($NSG.SecurityRules | where-object { ($_.Direction -eq "Inbound") -and ($_.SourceAddressPrefix -contains $allowed_public_IP) -and ($_.DestinationPortRange -contains "3389") }).access

            $access | Should -Be 'Allow'
        }
    }

    context "Server(s) check" -ForEach $servers {

        it "Server <name> does exist" {

            $server_exist = (Get-AzVM | Where-Object { ($_.ResourceGroupName -eq $rg_name) -and ($_.Name -eq $name) }).count

            $server_exist | should -Be 1
        }

        it "Server <name> size is <server_size>" {

            $server_size_test = (Get-AzVM -ResourceGroupName $rg_name -Name $name).HardwareProfile.VmSize

            $server_size_test | should -Be $size
        }
    }

    context "Server(s) count check" {
        
        it "Server(s) count is <server_count>" {
        
            $server_counts_test = (Get-AzVM -ResourceGroupName $rg_name).count

            $server_counts_test | should -Be $server_count
        }
    }
}
