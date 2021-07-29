$ComputerList = @();
$ComputerList += $env:COMPUTERNAME;

foreach ($ComputerName in $ComputerList)
{
    Enable-PSRemoting -Force
    (Get-CimInstance CIM_ComputerSystem -ComputerName $ComputerName).Name;
};

$ComputerName = $env:COMPUTERNAME;
Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType=3" |
Select-Object -Property DeviceID, DriveType, FreeSpace, Size, VolumeName;

$ComputerName = $env:COMPUTERNAME;
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType=3" |
Select-Object DeviceID, DriveType, FreeSpace, Size, VolumeName;

# Check if PSRemoting is enabled;
Enter-PSSession -ComputerName $ComputerName;
Exit-PSSession;