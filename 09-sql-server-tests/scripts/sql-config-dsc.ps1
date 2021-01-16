Configuration SQLServerConfiguration {  
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc
    Import-DSCResource -ModuleName NetworkingDsc


    Node "localhost"
    {
        $NumberOfCores = (Get-WmiObject -class Win32_processor).NumberOfCores
        $InstanceName = 'MSSQLSERVER'
        $SQLport = 6007
        $SMBport = 445
        # $rPSport = "5985-5986"

        $MaxDop = switch ($NumberOfCores) {
            1 { 1 }
            2 { 2 }
            4 { 4 }
            6 { 6 }
            8 { 8 }
            default { 8 }
        }

        $PhysicalRAM = [Math]::Round(((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB))

        $MaxMemor = ($PhysicalRAM - ($PhysicalRAM - ($PhysicalRAM % 16)) / 16 - 2) * 1024                       

        SqlConfiguration remote_admin_connections
        {
            Servername   = $NodeName
            InstanceName = $InstanceName
            OptionName   = 'remote admin connections'
            OptionValue  = 1
        }
        SqlConfiguration backup_compression_default
        {
            Servername   = $NodeName
            InstanceName = $InstanceName
            OptionName   = 'backup compression default'
            OptionValue  = 1
        }
        SqlConfiguration cost_threshold_for_parallelism
        {
            Servername   = $NodeName
            InstanceName = $InstanceName
            OptionName   = 'cost threshold for parallelism'
            OptionValue  = 50
        }

        SqlMaxDop SetSQLServerMaxDop
        {
            Ensure       = 'Present'
            DynamicAlloc = $false
            MaxDop       = $MaxDop
            ServerName   = $NodeName
            InstanceName = $InstanceName
        }

        SqlMemory SetSQLServerMaxMemory
        {
            Ensure       = 'Present'
            DynamicAlloc = $false
            MaxMemory    = $MaxMemor
            ServerName   = $NodeName
            InstanceName = $InstanceName
        }

        ServiceSet SQLServiceSetToManualAndStop {
            Name        = @("MsDtsServer150", "SSISTELEMETRY150", "SQLTELEMETRY", "SSASTELEMETRY", "MSSQLServerOLAPService")
            StartupType = "Manual"
            State       = "Stopped"
        }
    
        ServiceSet SQLServiceSetToAutomaticAndStart {
            Name        = @("SQLSERVERAGENT")
            StartupType = "Automatic"
            State       = "Running"
        }

        Registry ConfigureSQLMixedAuthentication {
            Ensure    = "Present"
            Key       = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQLServer"
            ValueName = "LoginMode"
            ValueData = "2"
            ValueType = "Dword"
        }

        SqlProtocolTcpIP 'ChangeIPAll'
        {
            InstanceName           = $InstanceName
            IpAddressGroup         = 'IPAll'
            TcpPort                = $SQLport
        }

        Firewall Firewall4SQL
        {
            Name                  = 'SQL-tcp-' + $SQLport
            DisplayName           = 'SQL-tcp-' + $SQLport
            Ensure                = 'Present'
            Enabled   = 'True'
            Direction = 'InBound'
            LocalPort = $SQLport
            Protocol  = 'TCP'
            Description           = 'SQL access on tcp\' + $SQLport
        }

        Firewall Firewall4SMB
        {
            Name                  = 'SMB-tcp-' + $SMBport
            DisplayName           = 'SMB-tcp-' + $SMBport
            Ensure    = 'Present'
            Enabled   = 'True'
            Direction = 'InBound'
            LocalPort = $SMBport
            Protocol  = 'TCP'
            Description           = 'File share access on tcp\' + $SMBport
        }

        # Firewall Firewall4rPS
        # {
        #     Name                  = 'SQL-tcp-' + $rPSport
        #     DisplayName           = 'SQL-tcp-' + $rPSport
        #     Ensure    = 'Present'
        #     Enabled   = 'True'
        #     Direction = 'InBound'
        #     LocalPort = $rPSport
        #     Protocol  = 'TCP'
        #     Description           = 'Remote PS access on tcp\' + $rPSport
        # }        



        # service start timeout extension to 60s
        Registry ServicesPipeTimeout {
            Ensure    = "Present"
            Key       = "HKLM:\SYSTEM\CurrentControlSet\Control"
            ValueName = "ServicesPipeTimeout"
            ValueData = "60000"
            ValueType = "Dword"
        }

    }
}

if (Test-Path -Path C:\Maintenance\DscConfiguration) { Remove-Item  -Path C:\Maintenance\DscConfiguration -Recurse -Force }

SQLServerConfiguration -OutputPath "C:\Maintenance\DscConfiguration"

Start-DscConfiguration -Wait -Verbose -Force -Path "C:\Maintenance\DscConfiguration"