
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("MachineAccessRestriction","MachineLaunchRestriction","DefaultLaunchPermission","DefaultAccessPermission")]
        [System.String]
        $ComObject,
        [System.String]
        $SID
    )


        switch($ComObject){
            'MachineAccessRestriction' {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'MachineLaunchRestriction' {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'DefaultLaunchPermission'  {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'DefaultAccessPermission'  {$PermissonGroup = 'A;;CCDCLC;;;'}
        }


        Write-Verbose -Message ("Checking permissons on COM object {1} to see if SID {0} is present." -f $SID, $ComObject)
        $Reg = [wmiclass]::new("\root\default:StdRegProv")
        $DCOM = $Reg.GetBinaryValue(2147483650,"software\microsoft\ole","$ComObject").uValue
        $BinaryConverter = [system.management.ManagementClass]::new("Win32_SecurityDescriptorHelper")
        $Result = $Binaryconverter.BinarySDToSDDL($DCOM).SDDL -match ("{0}{1}" -f $PermissonGroup,$SID)
          
        if($Matches.values  -match $SID){
            Write-Verbose ("COM object {1} is permissoned with {0}." -f $SID,$ComObject )
            $ReturnResult = $True
        }else{
            Write-Verbose ("COM object {1} is not permissoned with {0}." -f $SID,$ComObject )
            $ReturnResult = $False
        }

        $returnValue = @{
            SID = $SID
            ComObject = $ComObject
            Ensure = $ReturnResult
        }

        $returnValue

}


function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("MachineAccessRestriction","MachineLaunchRestriction","DefaultLaunchPermission","DefaultAccessPermission")]
        [System.String]
        $ComObject,

        [System.String]
        $SID,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )


        switch($ComObject){
            'MachineAccessRestriction' {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'MachineLaunchRestriction' {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'DefaultLaunchPermission'  {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'DefaultAccessPermission'  {$PermissonGroup = 'A;;CCDCLC;;;'}
        }


        $DCOMSDDL = ("{0}{1}" -f $PermissonGroup,$sid)
        Write-Verbose -Message ("Getting permissons configuration on COM {0} with SID {1}. To set the correct SID" -f $SID, $ComObject)
        $BinaryConverter =  [system.management.ManagementClass]::new("Win32_SecurityDescriptorHelper")

        if($ComObject -match "DefaultAccessPermission"){
            $KeyExists = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Ole -Name $ComObject -ErrorAction SilentlyContinue
            if(-not($KeyExists)){
                $TempDCOMSDDL = 'O:BAG:BAD:(A;;CCDCLC;;;PS)(A;;CCDC;;;SY)(A;;CCDCLC;;;BA)'
                $DCOMbinarySD = $BinaryConverter.SDDLToBinarySD($TempDCOMSDDL)
                $DCOMconvertedPermissions = $DCOMbinarySD.BinarySD
                New-Item -Path HKLM:\SOFTWARE\Microsoft\Ole -Name $ComObject -ItemType Binary -Value $DCOMconvertedPermissions
            }
        }

        $Reg = [wmiclass]::new("\root\default:StdRegProv")
        $DCOM = $Reg.GetBinaryValue(2147483650,"software\microsoft\ole","$ComObject").uValue
        $NewDCOMSDDL = $BinaryConverter.BinarySDToSDDL($DCOM).SDDL += "(" + $DCOMSDDL + ")"
        $DCOMbinarySD = $BinaryConverter.SDDLToBinarySD($NewDCOMSDDL)
        $DCOMconvertedPermissions = $DCOMbinarySD.BinarySD
        Write-Verbose -Message ("Setting permissons on COM preference {0} with SID {1}" -f $SID, $ComObject)
        $Reg.SetBinaryValue(2147483650,"software\microsoft\ole","$ComObject", $DCOMbinarySD.binarySD)


}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("MachineAccessRestriction","MachineLaunchRestriction","DefaultLaunchPermission","DefaultAccessPermission")]
        [System.String]
        $ComObject,

        [System.String]
        $SID,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )


        switch($ComObject){
            'MachineAccessRestriction'{$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'MachineLaunchRestriction'{$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'DefaultLaunchPermission' {$PermissonGroup = 'A;;CCDCLCSWRP;;;'}
            'DefaultAccessPermission' {$PermissonGroup = 'A;;CCDCLC;;;'}
        }

        Write-Verbose -Message ("Checking permissons on COM object {1} to see if SID {0} is present." -f $SID, $ComObject)
        $Reg = [wmiclass]::new("\root\default:StdRegProv")
        $DCOM = $Reg.GetBinaryValue(2147483650,"software\microsoft\ole","$($ComObject)").uValue
        $BinaryConverter = [system.management.ManagementClass]::new("Win32_SecurityDescriptorHelper")
        $Result = $Binaryconverter.BinarySDToSDDL($DCOM).SDDL -match ("{0}{1}" -f $PermissonGroup,$SID)
 
        if($Matches.values -match $SID){
            Write-Verbose ("COM {1} preference is permissoned with {0}." -f $SID,$ComObject )
            [System.Boolean]$Result = $true
            Write-Verbose ("Is DSC resource in desired state? {0}" -f $Result )
        }else{
            Write-Verbose ("COM {1} preference is permissoned with {0}." -f $SID,$ComObject )
            [System.Boolean]$Result = $false
            Write-Verbose ("Is DSC resource in desired state? {0}" -f $Result )
       }

    Return $Result
    
}


Export-ModuleMember -Function *-TargetResource
