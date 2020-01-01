# PSVirtualBox

## Archived

This module has been archived and should be considered deprecated. It has not been updated in a number of years and there is no guarantee that any of the code will work with newer versions of VirtualBox. You are welcome to use the code but be warned.

## Original Readme

A PowerShell module to manage a Virtual Box environment. This module was developed for an older version of Virtual Box
so I am sure it needs some updating.

TOPIC
    about_PSVirtualBox

SHORT DESCRIPTION
    These functions are wrappers to the underlying COM objets and APIs that you can use to manage
    a virtual machine infrastructure based on the VirtualBox application, which you can download 
    for free from Oracle at http://www.virtualbox.org

LONG DESCRIPTION
    The free virtualization application from Oracle, VirtualBox, offers an application SDK which
    at this point does not include native PowerShell support. This module is an attempt to utilize
    the VirtualBox COM object to perform common management tasks for virtual machines running
    in the VirtualBox environment.
    
$VBOX GLOBAL VARIABLE
    When you import the module, a global variable is created for the main VirtualBox COM object. 
    This variable, $vbox, is used by many of the support functions. It will be removed when you
    remove the module. If the variable does not exist when you call a function, that requires it,
    it will be recreated in the global scope.
    
    PS S:\> $vbox

    Version              : 4.0.8
    Revision             : 71778
    PackageType          : WINDOWS_64BITS_GENERIC
    HomeFolder           : C:\Users\Jeff/.VirtualBox
    SettingsFilePath     : C:\Users\Jeff/.VirtualBox\VirtualBox.xml
    Host                 : System.__ComObject
    SystemProperties     : System.__ComObject
    Machines             : {Win2008 R2 Standard, Win7, CoreDC01, Exchange...}
    HardDisks            : {Win2K8R2.vmdk, R2CoreAD.vmdk, ExchangeStore.vdi, 2008x86.vdi...}
    DVDImages            : {VBoxGuestAdditions.iso, en_windows_xp_professional_with_service_pack_3_x86_cd_x14-80428.iso, 76
                           01.17514.101119-1850_Update_Sp_Wave1-GRMSP1.1_DVD.iso, VBoxGuestAdditions.iso...}
    FloppyImages         : {}
    ProgressOperations   : {2b94ee0d-c330-4a95-89e3-5eec2ca67937, e0290bb2-ab2e-4a2e-85fa-84c7d5c81691, f5d8e502-bfc2-40dc-
                           a880-890c96677061, fe931e5a-66ca-4317-b6f7-5520026aa7f3}
    GuestOSTypes         : {Other, Windows31, Windows95, Windows98...}
    SharedFolders        :
    PerformanceCollector : System.__ComObject
    DHCPServers          : {HostInterfaceNetworking-VirtualBox Host-Only Ethernet Adapter, HostInterfaceNetworking-VirtualB
                           ox Host-Only Ethernet Adapter #2}
    EventSource          : System.__ComObject
    ExtensionPackManager : System.__ComObject
    
CASE SENSITIVE NAMES
    When passing virtual machine names, be aware that they are CaSe SenSiTive.
    
CUSTOM OBJECTS AND NATIVE COM OBJECTS  
    The Get-VBoxMachine is often used to get virtual machine objects and most other functions in 
    the module will take pipelined input from this function. Get-VBoxMachine writes a custom 
    object to the pipeline with commonly used properties. If you want to see the complete COM
    object, use the -IncludeRaw parameter.
    
    PS S:\> $vm=Get-VBoxMachine -Name "CoreDC01" -IncludeRaw
    PS S:\> $vm.raw

    Parent                            : System.__ComObject
    Accessible                        : 1
    AccessError                       :
    Name                              : CoreDC01
    Description                       :
    Id                                : ed29417c-869a-45bf-bbf3-79a407ade630
    OSTypeId                          : Windows2008_64
    HardwareVersion                   : 2
    HardwareUUID                      : ed29417c-869a-45bf-bbf3-79a407ade630
    CPUCount                          : 1
    CPUHotPlugEnabled                 : 0
    CPUExecutionCap                   : 100
    MemorySize                        : 512
    MemoryBalloonSize                 : 0
    PageFusionEnabled                 : 0
    VRAMSize                          : 16
    Accelerate3DEnabled               : 0
    Accelerate2DVideoEnabled          : 0
    MonitorCount                      : 1
    BIOSSettings                      : System.__ComObject
    FirmwareType                      : 1
    PointingHidType                   : 2
    KeyboardHidType                   : 2
    HpetEnabled                       : 0
    ChipsetType                       : 1
    SnapshotFolder                    : C:\Users\Jeff\.VirtualBox\Machines\CoreDC01\Snapshots
    VRDEServer                        : System.__ComObject
    MediumAttachments                 : {System.__ComObject, System.__ComObject, System.__ComObject}
    USBController                     : System.__ComObject
    AudioAdapter                      : System.__ComObject
    StorageControllers                : {IDE Controller, Floppy Controller}
    SettingsFilePath                  : C:\Users\Jeff\.VirtualBox\Machines\CoreDC01\CoreDC01.xml
    SettingsModified                  :
    SessionState                      : 2
    SessionType                       : headless
    SessionPid                        : 1876
    State                             : 5
    LastStateChange                   : 1307967948068
    StateFilePath                     :
    LogFolder                         : C:\Users\Jeff\.VirtualBox\Machines\CoreDC01\Logs
    CurrentSnapshot                   : System.__ComObject
    SnapshotCount                     : 3
    CurrentStateModified              : 1
    SharedFolders                     : {scripts}
    ClipboardMode                     : 3
    GuestPropertyNotificationPatterns :
    TeleporterEnabled                 : 0
    TeleporterPort                    : 0
    TeleporterAddress                 :
    TeleporterPassword                :
    FaultToleranceState               : 1
    FaultTolerancePort                : 0
    FaultToleranceAddress             :
    FaultTolerancePassword            :
    FaultToleranceSyncInterval        : 0
    RTCUseUTC                         : 0
    IoCacheEnabled                    : 1
    IoCacheSize                       : 5
    BandwidthControl                  : System.__ComObject
    PciDeviceAssignments              : {}
    
VERSION
    0.9
    June 13, 2011
    
SEE ALSO
    Get-VirtualBox
    Get-VBoxProcess
    Get-VBoxMachine
    Stop-VBoxMachine
    Start-VBoxMachine
    Suspend-VBoxMachine
