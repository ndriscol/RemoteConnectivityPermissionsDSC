<#
    .SYNOPSIS
        Example to setup COM permissioning on a node 
    .DESCRIPTION
        This examples add a SID into one of the COM Security groups.
#>
Configuration Sample_xCom
{
    param
    (
        [Parameter()]
        [String[]]
        $NodeName = 'localhost'
    )

    Import-DSCResource -ModuleName xRemoteConnectivity

    Node $NodeName
    {
        xCom SetUserAccount
        {
          Sid       = 'S-1-5-11'
          ComObject = 'DefaultAccessPermission'
          Ensure    = 'Present'
        }
    }
}

Sample_xCom
Start-DscConfiguration -Path Sample_xCom -Wait -Verbose -Force