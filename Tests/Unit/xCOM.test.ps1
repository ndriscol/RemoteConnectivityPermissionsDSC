$Global:DSCModuleName      = 'xRemoteConnectivity'
$Global:DSCResourceName    = 'xCom'

# Unit Test Template Version: 1.2.0
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $script:moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force

$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCResourceName `
    -TestType Unit 

#endregion HEADER

function Invoke-TestCleanup {
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}

try{
    InModuleScope $script:DSCResourceName{
        Describe $Global:DSCResourceName{

            Context "A host entry doesn't exist, and should" {
                $testParams = @{
                    SID = "S-1-5-11"
                    ComObject = 'DefaultAccessPermission'
                }
                It "should return absent from the get method" {
                    (get-TargetResource @testParams).Ensure | Should Be $false
                }

                It "should return false from the test method" {
                    Test-TargetResource @testParams | Should Be $false
                }

            }
        }
     }
  }catch [system.exeception]{


    $_

    }



           
