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

            Context "$($Global:DSCResourceName)\Get-TargetResource" {
                $testParams = @{
                    SID = "S-1-5-32-562"
                    ComObject = 'MachineLaunchRestriction'
                }

                $testParams2 = @{
                    SID = "S-1-5-21-21"
                    ComObject = 'DefaultLaunchPermission'
                }

                It "It should return true from ensure." {
                    (get-TargetResource @testParams).Ensure | Should Be $true
                }

                It "It should return false from ensure." {
                    (get-TargetResource @testParams2).Ensure | Should Be $false
                }

                It "It should return the SID of the user account." {
                    (get-TargetResource @testParams).SID  | Should Be 'S-1-5-32-562'
                }

                It "It should return the input Comobject." {
                    (get-TargetResource @testParams).ComObject  | Should Be 'MachineLaunchRestriction'
                }

             }

            Context "$($Global:DSCResourceName)\Test-TargetResource" {
                It "should return true from the test method" {
                    Test-TargetResource @testParams | Should Be $true
                }
            }

            Context "$($Global:DSCResourceName)\Set-TargetResource" {
                $testParams = @{
                    SID = "S-1-5-21-1606980848-4368372169-844533115-13282"
                    ComObject = 'MachineLaunchRestriction'
                }

                $testParams1 = @{
                    SID = "S-1-5-21-1606980848-4368372169-844533115-13282"
                    ComObject = 'MachineAccessRestriction'
                }

                $testParams2 = @{
                    SID = "S-1-5-21-1606980848-4368372169-844533115-13282"
                    ComObject = 'DefaultLaunchPermission'
                }

                $testParams3 = @{
                    SID = "S-1-5-21-1606980848-4368372169-844533115-13282"
                    ComObject = 'DefaultAccessPermission'
                }

                It "should return true from the Set method for MachineLaunchRestriction" {
                    Set-TargetResource @testParams | Should Be $true
                }

                It "should return true from the Set method for MachineAccessRestriction" {
                    Set-TargetResource @testParams1 | Should Be $true
                }

                It "should return true from the Set method for DefaultLaunchPermission" {
                    Set-TargetResource @testParams2 | Should Be $true
                }

                It "should return true from the Set method for DefaultAccessPermission" {
                    Set-TargetResource @testParams2 | Should Be $true
                }
            }
        }
    }

  }finally{
        Restore-TestEnvironment -TestEnvironment $TestEnvironment
   }


           
