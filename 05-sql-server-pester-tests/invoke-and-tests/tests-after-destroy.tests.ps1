$rg_name = "A-D1-DM3-RG"

describe 'Azure congifuration test' {

    context "Check if recource group exist" {

        $rg_exist = ((Get-AzResourceGroup | where { $_.ResourceGroupName -eq $rg_name }).count -gt 0)

        it "Resource group ($($rg_name)) does not exist" {
            $rg_exist | should be $false
        }
    }
}