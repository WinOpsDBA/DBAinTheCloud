$sql_configuration = @(
    @{ name = 'remote admin connections'; value = 1 }
    @{ name = 'backup compression default'; value = 1 }
    @{ name = 'max degree of parallelism'; value = 1 }
    @{ name = 'cost threshold for parallelism'; value = 50 }
    @{ name = 'max server memory (MB)'; value = 13312 }
)

$sql_service = @(
    @{ name = 'MSSQLSERVER'; status = 'Running' }
    @{ name = 'SQLBrowser'; status = 'Stopped' }
    @{ name = 'SQLSERVERAGENT'; status = 'Running' }
    @{ name = 'SQLTELEMETRY'; status = 'Stopped' }
    @{ name = 'SSASTELEMETRY'; status = 'Stopped' }
    @{ name = 'SQLWriter'; status = 'Running' }
    @{ name = 'MSSQLFDLauncher'; status = 'Running' }
    @{ name = 'MSSQLLaunchpad'; status = 'Stopped' }
    @{ name = 'MSSQLServerOLAPService'; status = 'Stopped' }
)

BeforeAll {
    $sql_instance = "a-d1-dm9-sql1,6007"
    $server_name = $sql_instance.Split(',')[0]
}

context "sql_configuration" -ForEach $sql_configuration {

    it "setting name: <name> is <value>" {

        $sql = @"
select value_in_use from sys.configurations
where name = '$($name)'
"@

        $current_value = (Invoke-Sqlcmd -ServerInstance $sql_instance -Query $sql).value_in_use # -As DataSet

        $current_value | should -Be $value
    }
}

context "sql_service" -ForEach $sql_service {

    it "service name: <name> is <status>" {

        $current_ststus = (Get-Service -ComputerName $server_name -Name $name -ErrorAction SilentlyContinue).status

        $current_ststus | should -Be $status

    }
}

context "sql_connectivity" {

    it "is working" {
        
        $server_name = (Invoke-Sqlcmd -ServerInstance $sql_instance -Query "select @@servername as server_name").server_name # -As DataSet

        $server_name | should -Be $server_name

    }
}

context "sql_authentication" {

    it "is mixed" {
        
        $sql_authentication = (Invoke-Sqlcmd -ServerInstance $sql_instance -Query "SELECT SERVERPROPERTY('IsIntegratedSecurityOnly') as MixedAuthentication").MixedAuthentication

        $sql_authentication | should -Be 0

    }
}