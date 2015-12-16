#Requires -version 2.0

<#

TODO:
Integrate Progress bar
Create new VM
Create a new HDD

#>

<#
  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
#>

Function Get-VirtualBox {

<#
.SYNOPSIS
Get the VirtualBox service
.DESCRIPTION
Create a PowerShell object for the VirtualBox COM object.
.EXAMPLE
PS C:\> $vbox=Get-VirtualBox
Create a variable $vbox to referece the VirtualBox service
.NOTES
NAME        :  Get-VirtualBox
VERSION     :  0.9
LAST UPDATED:  6/10/2011
AUTHOR      :  Jeffery Hicks
.LINK
Get-VBoxMachine
Stop-VBoxMachine
Start-VBoxMachine
Suspend-VBoxMachine
.INPUTS
None
.OUTPUTS
COM Object
#>

[cmdletbinding()]
Param()

Write-Verbose "Starting $($myinvocation.mycommand)"
#create vbox app
Write-Verbose "Creating the VirtualBox COM object"
$vbox = New-Object -ComObject "VirtualBox.VirtualBox"

$vbox
Write-Verbose "Ending $($myinvocation.mycommand)"

}

Function Get-VBoxMachine {

<#
.SYNOPSIS
Get a VirtualBox virtual machine
.DESCRIPTION
Retrieve any or all vritual box machines by name, by state or all. The default usage, without any parameters is to display all running virtual machines. Use -IncludeRaw to add the native COM object for the virtual machine.
.PARAMETER Name
The name of a virtual machine. IMPORTANT: Names are case sensitive.
.PARAMETER All
Return all virtual machines regardless of state. Valid values are:
"Stopped","Running","Saved","Teleported","Aborted","Paused","Stuck","Snapshotting",
"Starting","Stopping","Restoring","TeleportingPausedVM","TeleportingIn","FaultTolerantSync",
"DeletingSnapshotOnline","DeletingSnapshot", and "SettingUp"
.PARAMETER State
Return virtual machines based on their state.
.PARAMETER IncludeRaw
Include the raw or native COM object for the virtual machine.
.EXAMPLE
PS C:\> Get-VBoxMachine
ID          : 96c58d09-37be-46b1-9f4b-d37ea6da4005
Name        : Win2008 R2 Standard
MemoryMB    : 1500
Description : Windows 2008 R2 Standard DC jdhlab.local
State       : Running
OS          : Windows2008_64

ID          : ed29417c-869a-45bf-bbf3-79a407ade630
Name        : CoreDC01
MemoryMB    : 512
Description :
State       : Running
OS          : Windows2008_64

ID          : 2dd7f99a-d209-4b1c-ad79-2fa34e2c229a
Name        : Ubuntu
MemoryMB    : 1024
Description : v11.04 Natty Narwhal
State       : Running
OS          : Ubuntu_64

Return all running virtual machines
.EXAMPLE
PS C:\> Get-VBoxMachine -Name CoreDC01
ID          : ed29417c-869a-45bf-bbf3-79a407ade630
Name        : CoreDC01
MemoryMB    : 512
Description :
State       : Running
OS          : Windows2008_64

Retrieve a machine by name. Names are case sensitive
.EXAMPLE
PS C:\> Get-VBoxMachine -State Saved
ID          : 2dd7f99a-d209-4b1c-ad79-2fa34e2c229a
Name        : Ubuntu
MemoryMB    : 1024
Description : v11.04 Natty Narwhal
State       : Saved
OS          : Ubuntu_64

Get suspended virtual machines
.NOTES
NAME        :  Get-VBoxMachine
VERSION     :  0.9
LAST UPDATED:  6/13/2011
AUTHOR      :  Jeffery Hicks
.LINK
Stop-VBoxMachine
Start-VBoxMachine
Suspend-VBoxMachine
.INPUTS
Strings for virtual machine names
.OUTPUTS
Custom Object
#>

[cmdletbinding(DefaultParameterSetName="All")]
Param(
[Parameter(Position=0)]
[string[]]$Name,
[Parameter(ParameterSetName="All")]
[switch]$All,
[Parameter(ParameterSetName="All")]
[ValidateSet("Stopped","Running","Saved","Teleported","Aborted",
   "Paused","Stuck","Snapshotting","Starting","Stopping",
   "Restoring","TeleportingPausedVM","TeleportingIn","FaultTolerantSync",
   "DeletingSnapshotOnline","DeletingSnapshot","SettingUp")]
[string]$State = "Running",
[switch]$IncludeRaw
)

Write-Verbose "Starting $($myinvocation.mycommand)"

#get global vbox variable or create it if it doesn't exist create it
if (-Not $global:vbox) {
    $global:vbox = Get-VirtualBox
}

if ($Name) {
 #get virtual machines by name
 Write-Verbose "Getting virtual machines by name"
 #initialize an array to hold virtual machines
 $vmachines = @()
 foreach ($item in $Name) {
   Write-Verbose "Finding $item"
   $vMachines+= $vbox.FindMachine($item)
 }
} #if $name
elseif ($All) {
 #get all machines
  Write-Verbose "Getting all virtual machines"
  $vmachines = $vbox.Machines
}
Else {
  Write-Verbose "Getting virtual machines with a state of $State"

  #convert State to numeric value
 Switch ($state) {
   "Stopped"                {$istate =  1}
   "Saved"                  {$istate =  2}
   "Teleported"             {$istate =  3}
   "Aborted"                {$istate =  4}
   "Running"                {$istate =  5}
   "Paused"                 {$istate =  6}
   "Stuck"                  {$istate =  7}
   "Snapshotting"           {$istate =  8}
   "Starting"               {$istate =  9}
   "Stopping"               {$istate = 10}
   "Restoring"              {$istate = 11}
   "TeleportingPausedVM"    {$istate = 12}
   "TeleportingIn"          {$istate = 13}
   "FaultTolerantSync"      {$istate = 14}
   "DeletingSnapshotOnline" {$istate = 15}
   "DeletingSnapshot"       {$istate = 16}
   "SettingUp"              {$istate = 17}

  }

  $vmachines=$vbox.Machines | where {$_.State -eq $iState}
}

Write-Verbose "Found $(($vmachines | measure-object).count) virtual machines"
if ($vmachines) {
#write a virtual machine object to the pipeline
foreach ($vmachine in $vmachines) {

  #Decode state
  Switch ($vmachine.State) {
   1 {$vstate = "Stopped"}
   2 {$vstate = "Saved"}
   3 {$vstate = "Teleported"}
   4 {$vstate = "Aborted"}
   5 {$vstate = "Running"}
   6 {$vstate = "Paused"}
   7 {$vstate = "Stuck"}
   8 {$vstate = "Snapshotting"}
   9 {$vstate = "Starting"}
   10 {$vstate = "Stopping"}
   11 {$vstate = "Restoring"}
   12 {$vstate = "TeleportingPausedVM"}
   13 {$vstate = "TeleportingIn"}
   14 {$vstate = "FaultTolerantSync"}
   15 {$vstate = "DeletingSnapshotOnline"}
   16 {$vstate = "DeletingSnapshot"}
   17 {$vstate = "SettingUp"}

   Default {$vstate = $vmachine.State}
  }

  $obj = New-Object -TypeName PSObject -Property @{
     Name = $vmachine.name
     State = $vstate
     Description = $vmachine.description
     ID = $vmachine.ID
     OS = $vmachine.OSTypeID
     MemoryMB = $vmachine.MemorySize
  }
  if ($IncludeRaw) {
    #add raw COM object as a property
    $obj | Add-Member -MemberType Noteproperty -Name Raw -Value $vmachine -passthru
  }
  else {
    $obj
  }
} #foreach
} #if vmachines
else {
  Write-Host "No matching virtual machines found. Machine names are CaSe SenSitIve." -ForegroundColor Magenta
}
Write-Verbose "Ending $($myinvocation.mycommand)"
} #end function

Function Suspend-VBoxMachine {

<#
.SYNOPSIS
Suspend a virtual machine
.DESCRIPTION
This function will suspend or save the state of a running virtual machine. You must specify the virtual machine by its ID.
.PARAMETER ID
The ID or GUID of the running virtual machine.
.PARAMETER WhatIf
Show what the command would have processed
.PARAMETER Confirm
Confirm each suspension
.EXAMPLE
PS C:\> Get-VBoxMachine | Suspend-VBoxMachine
Suspend all running virtual machines
.NOTES
NAME        :  Suspend-VBoxMachine
VERSION     :  0.9
LAST UPDATED:  6/13/2011
AUTHOR      :  Jeffery Hicks
.LINK
Get-VBoxMachine
Stop-VBoxMachine
Start-VBoxMachine
.INPUTS
Strings
.OUTPUTS
None
#>

[cmdletbinding(SupportsShouldProcess=$True)]
Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter a virtual box machine ID",
ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullorEmpty()]
[GUID[]]$ID
)

Begin {
    Write-Verbose "Ending $($myinvocation.mycommand)"
    #get global vbox variable or create it if it doesn't exist create it
    if (-Not $global:vbox) {
        $global:vbox = Get-VirtualBox
    }
} #Begin

Process {
 foreach ($item in $ID) {

 #get the virtual machine
 $vmachine = $vbox.FindMachine($item)

 if ($vmachine) {
     Write-Host "Suspending $($vmachine.name)" -ForegroundColor Cyan
     if ($pscmdlet.ShouldProcess($vmachine.name)) {
         #create Vbox session object
         Write-Verbose "Creating a session object"
         $vsession = New-Object -ComObject "VirtualBox.Session"
         #launch the VMProcess to lock in write mode
         Write-verbose "Locking the machine"
         $vmachine.LockMachine($vsession,1)
         #run the SaveState() method
         Write-Verbose "Saving State"
         $vsession.Machine.SaveState()
     } #should process
    }
    else {
      Write-Warning "Failed to find virtual machine with an id of $ID"
    }
 } #foreach $id
} #process

End {
    Write-Verbose "Ending $($myinvocation.mycommand)"
} #End

} #end function

Function Start-VBoxMachine {

<#
.SYNOPSIS
Start a virtual machine
.DESCRIPTION
Start one or more virtual box machines. The default is to start them in an interactive or GUI mode. But you can also run them headless which will start a new process window, but there will be no interactive console window.
.PARAMETER Name
The name of a virtual machine. IMPORTANT: Names are case sensitive.
.PARAMETER Headless
Run the virtual machine in a headless process.
.EXAMPLE
PS C:\> Start-VBoxMachine "Win7"
Starts the virtual machine called Win7 in a GUI mode.
.EXAMPLE
PS C:\> Start-VBoxMachine CoreDC01 -headless
Start virtual machine CoreDC01 headless.
.NOTES
NAME        :  Start-VBoxMachine
VERSION     :  0.9
LAST UPDATED:  6/13/2011
AUTHOR      :  SERENITY\Jeff
.LINK
Get-VBoxMachine
Stop-VBoxMachine
.INPUTS
Strings
.OUTPUTS
None
#>

[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter a virtual machine name",
ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullorEmpty()]
[string[]]$Name,
[switch]$Headless
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
   #get global vbox variable or create it if it doesn't exist create it
    if (-Not $global:vbox) {
        $global:vbox = Get-VirtualBox
    }
}#Begin

Process {
    foreach ($item in $name) {

      #get the virtual machine
      $vmachine=$vbox.FindMachine($item)

     if ($vmachine) {
         #create Vbox session object
         Write-Verbose "Creating a session object"
         $vsession = New-Object -ComObject "VirtualBox.Session"
        if ($vmachine.State -lt 5) {
          if ($Headless) {
            Write-Verbose "Starting in headless mode"
            $vmachine.LaunchVMProcess($vsession,"headless","")
          }
          else {
            $vmachine.LaunchVMProcess($vsession,"gui","")
          }
        }
        else {
          Write-Host "I can only start machines that have been stopped." -ForegroundColor Magenta
        }

    } #if vmachine

     } #foreach
} #process

End {
    Write-Verbose "Ending $($myinvocation.mycommand)"
} #End

} #end function

Function Stop-VBoxMachine {

<#
.SYNOPSIS
Stop a virtual machine
.DESCRIPTION
Stop one or more virtual box machines by sending the ACPI shutdown signal.
.PARAMETER Name
The name of a virtual machine. IMPORTANT: Names are case sensitive.
.PARAMETER Headless
Run the virtual machine in a headless process.
.EXAMPLE
PS C:\> Stop-VBoxMachine "Win7"
Stops the virtual machine called Win7
.EXAMPLE
PS C:\> Get-VBoxMachine | Stop-VBoxMachine
Stop all running virtual machines
.NOTES
NAME        :  Stop-VBoxMachine
VERSION     :  0.9
LAST UPDATED:  6/13/2011
AUTHOR      :  SERENITY\Jeff
.LINK
Get-VBoxMachine
Start-VBoxMachine
Suspend-VBoxMachine
.INPUTS
Strings
.OUTPUTS
None
#>


[cmdletbinding(SupportsShouldProcess=$True)]
Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter a virtual machine name",
ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullorEmpty()]
[string[]]$Name
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
   #get global vbox variable or create it if it doesn't exist create it
    if (-Not $global:vbox) {
        $global:vbox = Get-VirtualBox
    }
} #Begin

Process {
    foreach ($item in $name) {

      #get the virtual machine
      $vmachine=$vbox.FindMachine($item)

     if ($vmachine) {
      if ($pscmdlet.ShouldProcess($vmachine.name)) {
         #create Vbox session object
         Write-Verbose "Creating a session object"
         $vsession = New-Object -ComObject "VirtualBox.Session"
        if ($vmachine.State -eq 5) {
            Write-verbose "Locking the machine"
            $vmachine.LockMachine($vsession,1)
            #send ACPI shutdown signal
            $vsession.console.PowerButton()
          }
        else {
          Write-Host "I can only stop machines that are running." -ForegroundColor Magenta
        }
      } #should process
    } #if vmachine

     } #foreach
} #process

End {
    Write-Verbose "Ending $($myinvocation.mycommand)"
} #end

} #end function

Function Get-VBoxProcess {

<#
.SYNOPSIS
Get all VirtualBox related processes
.DESCRIPTION
Find all running processes related to VirtualBox.
.EXAMPLE
PS C:\> Get-VBoxProcess
Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id ProcessName
-------  ------    -----      ----- -----   ------     -- -----------
    401      56    36272      27956   139    36.63   1876 VBoxHeadless
    754     129   103736      52940   244    76.85  12244 VBoxHeadless
   3444      17    16076      11844   109 1,351.14   8176 VBoxSVC
    193      15    19416      55140   137     1.28  12212 VirtualBox

Get all running VirtualBox related processes
.NOTES
NAME        :  Get-VboxProcess
VERSION     :  0.9
LAST UPDATED:  6/13/2011
AUTHOR      :  Jeffery Hicks
.LINK
Get-VirtualBox
.INPUTS
None
.OUTPUTS
Process object
#>

[cmdletbinding()]
Param()

Write-Verbose "Starting $($myinvocation.mycommand)"
Try {
  $processes = Get-Process -ErrorAction "Stop" | Where {$_.path -match "oracle\\virt"}
  Write-Verbose "Found $($processes | measure-object).Count processes)"
  $processes
}
Catch {
  Write-Host "Failed to find any VirtualBox related processes." -ForegroundColor Magenta
}

Finally {
 Write-Verbose "Ending $($myinvocation.mycommand)"
}

} #end function

#########################################################################################

#Getting a reference to VirtualBox COM object
$vbox=Get-VirtualBox
$status="VirtualBox v{0} rev.{1}  Machines: {2}" -f $vbox.version,$vbox.revision,$vbox.machines.count
Write-Host $status -ForegroundColor Cyan

#Defining some aliases
New-Alias -Name gvbm -Value Get-VBoxMachine
New-Alias -Name stovbm -Value Stop-VBoxMachine
New-Alias -Name stavbm -Value Start-VBoxMachine
New-Alias -Name suvbm -Value Suspend-VBoxMachine
New-Alias -Name gvb -Value Get-VirtualBox
New-Alias -Name gvbp -Value Get-VBoxProcess

#Exporting some module members
Export-ModuleMember -Alias * -Function * -Variable vbox
