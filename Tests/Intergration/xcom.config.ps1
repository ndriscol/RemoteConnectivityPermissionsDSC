$TestConfigPath = Join-Path -Path $PSScriptRoot -ChildPath "Xcom.config.ps1"
$TestComObject = 'DefaultAccessPermission'
$TestSID = 'S-1-5-21'


configuration Xcom_config {
    Import-DscResource -ModuleName XWMIManagement
    node localhost {
        xcom Integration_Test {
            ComObject = $TestComObject
            SID = $TestSID
        }
    }
}

