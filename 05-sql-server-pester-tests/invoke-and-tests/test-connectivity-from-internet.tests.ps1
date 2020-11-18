$rg_name = "A-D1-DM3-RG"

describe 'Azure functionality test' {

    $public_IPs = (Get-AzPublicIpAddress -ResourceGroupName $rg_name).ipaddress

    context "RDP port (tcp\3389) is not accesible from the Internet" {

        foreach ($public_IP in $public_IPs) {

            $connection_test = Test-NetConnection -ComputerName $public_IP -port 3389 -InformationLevel Quiet

            it "Unable to connect to public IP ($($public_IP)) on port 3389" {
                $connection_test | should be "False"
            }
        }
    }
}