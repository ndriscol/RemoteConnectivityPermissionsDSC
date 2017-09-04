<#
    .SYNOPSIS
        Example to setup COM permissioning on a node 
    .DESCRIPTION
        This examples add a SID into one of the COM Security groups.
#>
Configuration Sample_MSFT_DCOMSecurityDSC
{
    param
    (
        [Parameter()]
        [String[]]
        $NodeName = 'localhost'
    )

    Import-DSCResource -ModuleName DCOMSecurityDSC

    Node $NodeName
    {
        MSFT_DCOMSecurityDSC SetUserAccount
        {
          Sid       = 'S-1-5-11'
          ComObject = 'DefaultAccessPermission'
          Ensure    = 'Present'
        }
    }
}

Sample_MSFT_DCOMSecurityDSC
Start-DscConfiguration -Path Sample_MSFT_DCOMSecurityDSC -Wait -Verbose -Force
