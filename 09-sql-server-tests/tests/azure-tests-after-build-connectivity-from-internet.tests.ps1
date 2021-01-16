$rg_name = "a-d1-dm9-rg"
$public_IPs = (Get-AzPublicIpAddress -ResourceGroupName $rg_name).ipaddress

context "RDP port (tcp\3389) is not accesible from the Internet" -ForEach $public_IPs {

    it "Unable to connect to public IP <_> on port 3389" {

        $connection_test = Test-NetConnection -ComputerName $_ -port 3389 -InformationLevel Quiet

        $connection_test | should -Be "False"
    }
}