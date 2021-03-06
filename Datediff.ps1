﻿param
(
    [string]$start,
    [string]$end,
    [int]$interval
);

<#
    .SYNOPSIS
    Diferença entre duas datas
    .DESCRIPTION
    Job criado com os parâmetros de data e de intervalo entre uma iteração e a seguinte.
    .PARAMETER start
    Data de início do período
    .PARAMETER end
    Data fim do período
    .PARAMETER interval
    Tempo em segundos
    .NOTES
    Author: Vladimir
    .EXAMPLE
        Start-Job `
            -Name DateDiff `
            -ScriptBlock {C:\Users\p623856\Documents\Shell\Datediff.ps1 -start (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') -end '2019-09-14 07:00:00' -interval (1*60*1)};
        Receive-Job -Name DateDiff;
        Stop-Job -Name DateDiff;
        Remove-Job -Name DateDiff;
#>

if (!$start)
{
    $start = (Get-Date).ToString('2018-09-10 09:30:00');
};
if (!$end)
{
    $end = (Get-Date).ToString('2019-09-14 07:00:00');
};
if (!$interval)
{
    $interval = 7;
};
$i = 1;
$qt_pad = 10;
$ch_pad = " ";
# $qt_min = 0;
# $qt_min_total = 0;
$n = 170/100;
$ts = New-TimeSpan -Start $start -End $end;

do {
    Clear-Host;
    Write-Host ('-' * ((100 * $n) + 3));
    $ts2 = New-TimeSpan -Start (Get-Date) -End $end;
    $pc = 1 - $ts2.TotalMinutes / $ts.TotalMinutes;

    Write-Host ([char]12321, (([char]9608).toString() * [Math]::Floor($pc * (100 * $n))).PadRight((100 * $n), ' '), [char]12321) ($pc).ToString('| 0.00% |');
    $Host.UI.RawUI.WindowTitle = ([char]12321, (([char]9608).toString() * [Math]::Floor($pc * (100 * 0.50))).PadRight((100 * 0.50), ' '), [char]12321), ($pc).ToString('| 0.00% |')

    Write-Host ('-' * ((100 * $n) + 3));
    Write-Host ('#', $i);
    Write-Host ('Start'.PadRight($qt_pad, $ch_pad), $start);
    Write-Host ('End'.PadRight($qt_pad, $ch_pad), $end);
    Write-Host ('Interval'.PadRight($qt_pad, $ch_pad), [timespan]::FromSeconds($interval).toString());


    Write-Host ('Days'.PadRight($qt_pad, $ch_pad), ([Math]::Ceiling($ts2.TotalDays)).ToString('0').PadLeft($qt_pad, $ch_pad), '|', ([Math]::Ceiling($ts.TotalDays)).ToString('0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Hours'.PadRight($qt_pad, $ch_pad), $ts2.TotalHours.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalHours.ToString('#,0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Minutes'.PadRight($qt_pad, $ch_pad), $ts2.TotalMinutes.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalMinutes.ToString('#,0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Seconds'.PadRight($qt_pad, $ch_pad), $ts2.TotalSeconds.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalSeconds.ToString('#,0').PadLeft($qt_pad, $ch_pad));

    Write-Host ('-' * ((100 * $n) + 3));

    #if ($qt_min -eq 0) {
    #   $qt_min = $ts.TotalMinutes;
    #};
    
    if ($interval -le 0)
    {
        break;
    };

    $i ++;
    
    if((Get-Date).Hour -eq 19)
    {
        Start-Sleep -Seconds (13*60*60);
    }
    else
    {
        Start-Sleep -Seconds ($interval);
    };

    #$start = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss');
}
while ($ts.TotalHours -ge 0);

Write-Host ('*' * ((100 * $n) + 3));

try
{
    Stop-Job -Name DateDiff;
    Remove-Job -Name DateDiff;
}
catch
{
    $_.Exception.Message;
};

<#  Bars in all available colours
    Clear-Host;
    $colors = [Enum]::GetValues([System.ConsoleColor]);
    foreach ($color in $colors)
    {
        Write-Host ([char]12321, (([char]9608).toString() * [int](((Get-Random -Minimum 90 -Maximum (100 + 1))/100) * 100)).PadRight(100, ' '), [char]12321) -ForegroundColor $color;
    };
#>