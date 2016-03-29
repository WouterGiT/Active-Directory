Function Add-NewOrganizationalUnit {
    <#
    .SYNOPSIS
        Create a new Organizational Unit
 
    .DESCRIPTION
        Create a new Organizational Unit, query the PDC as primary server
        Active Directory CMDLets are needed.
 
    .PARAMETER Name
        The name of the new Organizational Unit.

    .PARAMETER Path
        Specifies the OU were to create the new Organizational Unit.
 
    .EXAMPLE
         Add-NewOrganizationalUnit -Name 'OU Name'
    
    .EXAMPLE
         Add-NewOrganizationalUnit -Name 'OU Name' -Path 'OU=My Location,OU=Servers,DC=prutser,DC=me'

    .INPUTS
        String
 
    .OUTPUTS
        Creates a new Organizational Unit in Active Directory
        Status is outputted to screen
 
    .NOTES
        Author:  Wouter de Dood
        Website: 
        Twitter: @WMouter
    #>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$Name,
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$Path = 'OU=Customers,OU=Sales,DC=prutser,DC=me' #Set this path as default
    )
    Begin {
        $ErrorActionPreference = 'Stop'
        Try {
            Import-Module ActiveDirectory
        }
        Catch {
            Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Error] Module not loaded, ActiveDirectory Module is mandatory."
            Throw
        }
        $Identity = "OU=$Name,$Path"
        $Server   = (Get-ADDomainController -Service PrimaryDC -Discover).HostName #Target PDC of current domain
    }
    Process {
        $ErrorActionPreference = 'Stop'
        Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Action] Create Organizational Unit: $Name in $Path"
        Try {
            Get-ADOrganizationalUnit -Identity $Identity -Server $Server | Out-Null
        }
        Catch {
            $ouCreate = $true
        }

        if ($ouCreate -eq $true) {
            Try {
                New-ADOrganizationalUnit -Name $Name -Path $Path -Server $Server
                Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Status] Created"
            }
            Catch {
                Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Error] Not created!"
                Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Error] $($_.Exception.Message)"
            }
        } else {
            Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Status] No need to create already exists"
        }
    }
    End {
        Remove-Variable ouCreate,Name,Path,Server,Identity
    }

} #end function Add-NewOrganizationalUnit