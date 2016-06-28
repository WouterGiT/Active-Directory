Function Add-NewADGlobalGroup
{
    <#
    .SYNOPSIS
        Create a new Active Directory Global Group
 
    .DESCRIPTION
        Create a new Active Directory Global Group, query the PDC as primary server
        Active Directory CMDLets are needed.
        The group is only created of it doesn't exists.
 
    .PARAMETER Name
        The name of the new Global Group.

    .PARAMETER Path
        Specifies the OU were to create the new Global Group.
        "OU=New Group OU,OU=Groups,DC=prutser,DC=me"
 
    .EXAMPLE
        Add-NewADGlobalGroup -Name "Group Name" -Path "OU=New Group OU,OU=Groups,DC=prutser,DC=me"
    
    .EXAMPLE
        Add-NewADGlobalGroup -Name "GroupName" -Path "OU=prutser,DC=prutser,DC=me"

    .INPUTS
        String
 
    .OUTPUTS
        Creates a new Global Group in Active Directory.
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

        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$Path,

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$Description = ""
    )

    Begin
    {
        $ErrorActionPreference = 'Stop'
        Try
        {
            Import-Module ActiveDirectory
        }
        Catch
        {
            Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Error] Module not loaded, ActiveDirectory Module is mandatory."
            Throw
        }
        $Identity       = "CN=$Name,$Path"
        [string]$Server = (Get-ADDomainController -Service PrimaryDC -Discover).HostName #Target PDC of current domain
    }


    Process
    {
        $ErrorActionPreference = 'Stop'
        Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Action] Create group $Name in $Path"
        Try
        {
            Get-ADGroup -Identity $Identity -Server $Server | Out-Null
            $ouCreate = $false
        }
        Catch
        {
            $ouCreate = $true
        }

        if ($ouCreate -eq $true)
        {
            Try
            {
                New-ADGroup -Name $Name -Path $Path -GroupScope Global -Description $Description -Server $Server 
                Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Status] Created"
            }
            Catch
            {
                Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Error] Not created!"
                Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Error] $($_.Exception.Message)"
            }
        }
        else
        {
            Write-Output "[$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")] - [Status] No need to create already exists"
        }
    }


    End
    {
        Remove-Variable ouCreate,Name,Path,Server,Identity
    }
} #end function Add-NewADGlobalGroup