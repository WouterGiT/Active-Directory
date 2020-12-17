try
{
    $ErrorActionPreference = "stop"
    Install-WindowsFeature -Name AD-Domain-Services
    $password = Read-Host -Prompt 'Enter SafeMode Admin Password' -AsSecureString
    $installForest = @{
        CreateDnsDelegation           = $false
        DatabasePath                  = "F:\Windows\NTDS"
        LogPath                       = "F:\Windows\NTDS"
        SysvolPath                    = "G:\Windows\SYSVOL"
        InstallDns                    = $true
        NoRebootOnCompletion          = $false
        SafeModeAdministratorPassword = $password
        Force                         = $true
        DomainMode                    = 'WinThreshold'
        DomainName                    = "xxx.local"
        DomainNetbiosName             = 'xxxx'
        ForestMode                    = 'WinThreshold'
    
    }
    Install-ADDSForest @installForest
}
catch
{
    Write-Output "$($_.Exception.Message)"
}

<#
    Windows Server 2003: "Win2003" or "2"
    Windows Server 2008: "Win2008" or "3"
    Windows Server 2008 R2: Win2008R2 or "4"
    Windows Server 2012: "Win2012" or "5"
    Windows Server 2012 R2: "Win2012R2" or "6"
    Windows Server 2016: "WinThreshold" or "7"
#>
