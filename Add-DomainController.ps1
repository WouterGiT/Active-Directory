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
        DomainName                    = "xxxx.xxxx"
        InstallDns                    = $true
        NoRebootOnCompletion          = $false
        SafeModeAdministratorPassword = $password
        Force                         = $true
        Credential                    = Get-Credential
    }
    Install-ADDSDomainController @installForest
}
catch
{
    Write-Output "$($_.Exception.Message)"
}
