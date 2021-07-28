Clear-Host;

$ComputerName = $env:COMPUTERNAME;

Write-Host "Date:"(Get-Date).ToString("dd-MM-yyyy HH:mm:ss");
Write-Host "ComputerName: $ComputerName";

$disk = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName | #-Filter "DeviceID='C:'" |
Select-Object DeviceID, Size, FreeSpace, VolumeName;

foreach ($d in $disk)
{
    try
    {    
        Write-Host "Drive"$d.DeviceID $d.VolumeName;
        Write-Host "`tTotal Space: " -NoNewline;
        Write-Host ([math]::Round($d.Size / 1GB, 2).toString())"GB" -ForegroundColor Cyan;

        Write-Host ([char]10006) -ForegroundColor Red -NoNewline;
        Write-Host "`tUsed space:  " -NoNewline;
        Write-Host ([math]::Round(($d.Size - $d.FreeSpace) / 1GB, 2).toString())"GB" -ForegroundColor Red -NoNewline;
        Write-Host " "([Math]::Round(1 - ($d.FreeSpace / $d.Size), 2) * 100)"%" -ForegroundColor Red;

        Write-Host ([char]10004) -ForegroundColor Green -NoNewline;
        Write-Host "`tFree space:  " -NoNewline;
        Write-Host ([math]::Round($d.FreeSpace / 1GB, 2).toString())"GB" -ForegroundColor Green -NoNewline;
        Write-Host " "([Math]::Round($d.FreeSpace / $d.Size, 2) * 100)"%" -ForegroundColor Green;

        Write-Host "`t" -NoNewline
        Write-Host (([char]9611).toString() * (([Math]::Round(1 - ($d.FreeSpace / $d.Size), 2) * 100)* 0.3)) -ForegroundColor Red -NoNewline;
        Write-Host (([char]9611).toString() * (([Math]::Round($d.FreeSpace / $d.Size, 2) * 100) * 0.3)) -ForegroundColor Green 
    }
    catch
    {

    };
    Write-Host;
};