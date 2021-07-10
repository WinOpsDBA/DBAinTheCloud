BeforeAll {
    $rg_name = "a-d1-dm11-rg"
}

describe 'Azure_congifuration' {

    context "Check if recource group does not exist" {

        it "Resource group <rg_name> does not exist" {

            $rg_exist = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -eq $rg_name }).count

            $rg_exist | should -Be 0
            
        }
    }

}
