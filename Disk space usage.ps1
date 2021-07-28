Clear-Host;

$ComputerList = @();
$ComputerList += $env:COMPUTERNAME;

$bar_scale = 0.3;
$txt_out = $true;
$txt_file = [Environment]::GetFolderPath("MyDocuments") + "\disk_space_usage.txt";

Remove-Item -Path $txt_file -ErrorAction SilentlyContinue;

foreach ($ComputerName in $ComputerList)
{

    Write-Host "Date".PadRight(12, ' ')(Get-Date).ToString("dd-MM-yyyy HH:mm:ss");
    Write-Host "ComputerName".PadRight(12, ' ')$ComputerName;
    Write-Host ("-" * 35);

    $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName | #-Filter "DeviceID='C:'" |
    Select-Object DeviceID, Size, FreeSpace, VolumeName;

    Add-Content -Path $txt_file -Value ("Date`t" + (Get-Date).ToString("dd-MM-yyyy HH:mm:ss"));
    Add-Content -Path $txt_file -Value "ComputerName`t$ComputerName";
    Add-Content -Path $txt_file -Value ("." * 35);

    foreach ($d in $disk)
    {
        try
        {    
            Write-Host "Drive"$d.DeviceID $d.VolumeName;
            Write-Host "`tSize".PadRight(14, ' ') -NoNewline;
            Write-Host ([math]::Round($d.Size / 1GB, 2).toString('0.00')).PadLeft(7, ' ')"GB" -ForegroundColor Cyan;

            Write-Host ([char]10006) -ForegroundColor Red -NoNewline;
            Write-Host "`tUsed space".PadRight(14, ' ') -NoNewline;
            Write-Host ([math]::Round(($d.Size - $d.FreeSpace) / 1GB, 2).toString('0.00')).PadLeft(7, ' ')"GB" -ForegroundColor Red -NoNewline;
            Write-Host " "([Math]::Round(1 - ($d.FreeSpace / $d.Size), 2) * 100)"%" -ForegroundColor Red;

            Write-Host ([char]10004) -ForegroundColor Green -NoNewline;
            Write-Host "`tFree space".PadRight(14, ' ') -NoNewline;
            Write-Host ([math]::Round($d.FreeSpace / 1GB, 2).toString('0.00')).PadLeft(7, ' ')"GB" -ForegroundColor Green -NoNewline;
            Write-Host " "([Math]::Round($d.FreeSpace / $d.Size, 2) * 100)"%" -ForegroundColor Green;

            Write-Host "`t" -NoNewline
            Write-Host (([char]9611).toString() * (([Math]::Round(1 - ($d.FreeSpace / $d.Size), 2) * 100) * $bar_scale)) -ForegroundColor Red -NoNewline;
            Write-Host (([char]9611).toString() * (([Math]::Round($d.FreeSpace / $d.Size, 2) * 100) * $bar_scale)) -ForegroundColor Green;

            ### Write to file

            Add-Content -Path $txt_file -Value ("Drive " + $d.DeviceID + "`t" + $d.VolumeName);
            Add-Content -Path $txt_file -Value ((" `tSize`t".PadRight(11, ' ') + ([math]::Round($d.Size / 1GB, 2).toString('0.00')) + " GB"));
            Add-Content -Path $txt_file -Value ("-" + "`tUsed space`t" + ([math]::Round(($d.Size - $d.FreeSpace) / 1GB, 2).toString('0.00'))+ " GB" + "`t" + ([Math]::Round(1 - ($d.FreeSpace / $d.Size), 2) * 100) + "%");
            Add-Content -Path $txt_file -Value ("+" + "`tFree space`t" + ([math]::Round($d.FreeSpace / 1GB, 2).toString('0.00')) + " GB" + "`t" + ([Math]::Round($d.FreeSpace / $d.Size, 2) * 100) + "%");
            Add-Content -Path $txt_file -Value (" `t" + ("O" * (([Math]::Round(1 - ($d.FreeSpace / $d.Size), 2) * 100) * $bar_scale)) + ("." * (([Math]::Round($d.FreeSpace / $d.Size, 2) * 100) * $bar_scale)));
            Add-Content -Path $txt_file -Value ("" * 35);
        }
        catch
        {
            Write-Host;
        };
        Write-Host;
    };
    Add-Content -Path $txt_file -Value (("-" * 35) + "`r`n");
    Write-Host ("-" * 35);
};