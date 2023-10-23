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
    .PARAMETER bar_size
        Tamanho da barra de progesso no console
    .NOTES
        Author: Vladimir
    .EXAMPLE
        Start-Job `
        -Name DateDiff `
        -ScriptBlock {C:\Users\p623856\Documents\Shell\Datediff.ps1 -start (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') -end '2019-09-14 07:00:00' -interval (1*60*1) -bar_size 60};
        Receive-Job -Name DateDiff;
        Stop-Job -Name DateDiff;
        Remove-Job -Name DateDiff;
    .OUTPUTS
        -----------------------------------------------------------------
        〡 ██████████████████                                           〡 | 31,4% |
        -----------------------------------------------------------------
        # 21
        Start      2023-05-08 09:00:00
        End        2024-05-09 07:00:00
        Interval   00:00:07
        Days              252 |        367
        Hours           6.037 |      8.806
        Minutes       362.216 |    528.360
        Seconds    21.732.948 | 31.701.600
        -----------------------------------------------------------------
#>

param (
    [string]$start,
    [string]$end,
    [int]$interval = 1,
    [int]$bar_size = 60
);

<# For testing
    $start = (Get-Date).AddMinutes(-24 * 60 * 0).ToString('yyyy-MM-dd 09:12');
    # $end = ([datetime]$start).AddMinutes(24 * 60 * 1).toString("yyyy-MM-dd HH:mm");
    $end = ([datetime]$start).AddMinutes(588 + 0).toString("yyyy-MM-dd HH:mm");
    $bar_size = 60;
#>

$start = (!$start ? (Get-Date).ToString('2023-09-18 12:00:00') : $start);
$end = (!$end ? (Get-Date).ToString('2023-09-19 11:59:00') : $end);
$interval = (!$interval ? 1 : $interval);
$i = 1;
$qt_pad = 12;
$ch_pad = " ";
# $qt_min = 0;
# $qt_min_total = 0;
$n = $bar_size/100;
$ts = New-TimeSpan -Start $start -End $end;

do {
    Clear-Host;
    Write-Host ('-' * ((100 * $n) + 5));
    $ts2 = New-TimeSpan -Start (Get-Date) -End $end;
    $ts3 = New-TimeSpan -Start $start -End (Get-Date);
    $pc = 1 - $ts2.TotalMinutes / $ts.TotalMinutes;
    $ForegroundColor = 
        switch ([math]::Round($pc, 3)) {
            {$_ -ge 0 -and $_ -le 0.25} { 'DarkRed' }
            {$_ -gt 0.25 -and $_ -le 0.5} { 'DarkMagenta' }
            {$_ -gt 0.5 -and $_ -le 0.75} { 'DarkYellow' }
            {$_ -gt 0.75 -and $_ -le 1} { 'DarkGreen' }
            Default {'DarkBlue'}
        };
    Write-Host ([char]12321, (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))).PadRight((100 * $n), ' '), [char]12321) ($pc).ToString('| 0.0% |') -ForegroundColor $ForegroundColor;
    $Host.UI.RawUI.WindowTitle = ([char]12321, (([char]9608).toString() * [Math]::Floor($pc * (100 * 0.50))).PadRight((100 * 0.50), ' '), [char]12321), ($pc).ToString('| 0.0% |')

    Write-Host ('-' * ((100 * $n) + 5));
    Write-Host ('#', $i.ToString('#,0'));
    Write-Host ('Start'.PadRight($qt_pad, $ch_pad), $start, '|', 'Elapsed time'.PadRight($qt_pad, $ch_pad), "{0:hh\:mm\:ss}" -f, [timespan]::FromSeconds($ts3.TotalSeconds));
    Write-Host ('End'.PadRight($qt_pad, $ch_pad), $end, '|', 'Time left'.PadRight($qt_pad, $ch_pad), "{0:hh\:mm\:ss}" -f, [timespan]::FromSeconds($ts2.TotalSeconds));
    Write-Host ('Interval'.PadRight($qt_pad, $ch_pad), [timespan]::FromSeconds($interval).toString());

    Write-Host ('Days'.PadRight($qt_pad, $ch_pad), ([Math]::Ceiling($ts2.TotalDays)).ToString('0').PadLeft($qt_pad, $ch_pad), '|', ([Math]::Ceiling($ts.TotalDays)).ToString('0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Hours'.PadRight($qt_pad, $ch_pad), $ts2.TotalHours.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalHours.ToString('#,0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Minutes'.PadRight($qt_pad, $ch_pad), $ts2.TotalMinutes.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalMinutes.ToString('#,0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Seconds'.PadRight($qt_pad, $ch_pad), $ts2.TotalSeconds.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalSeconds.ToString('#,0').PadLeft($qt_pad, $ch_pad));

    Write-Host ('-' * ((100 * $n) + 5));

    #if ($qt_min -eq 0) {
    #   $qt_min = $ts.TotalMinutes;
    #};
    
    # if ($interval -le 0)
    # {
    #     break;
    # };

    $i ++;
    
    # if((Get-Date).Hour -eq 19)
    # {
    #     Start-Sleep -Seconds (13*60*60);
    # }
    # else
    # {
        Start-Sleep -Seconds ($interval);
    # };
    #$start = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss');
}
while ($ts2.TotalSeconds -ge 0);

Write-Host ('*' * ((100 * $n) + 3));

try
{
    Stop-Job -Name DateDiff -ErrorAction SilentlyContinue;
    Remove-Job -Name DateDiff -ErrorAction SilentlyContinue;
}
catch
{
    $_.Exception.Message;
};