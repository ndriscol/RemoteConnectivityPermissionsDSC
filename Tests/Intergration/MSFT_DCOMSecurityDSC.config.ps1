$TestConfigPath = Join-Path -Path $PSScriptRoot -ChildPa"MSFT_DCOMSecurityDSC.config.ps1"
$TestComObject = 'DefaultAccessPermission'
$TestSID = 'S-1-5-21'


configuration MSFT_DCOMSecurityDSC {
    Import-DscResource -ModuleName XWMIManagement
    node localhost {
        xcom Integration_Test {
            ComObject = $TestComObject
            SID = $TestSID
        }
    }
}

