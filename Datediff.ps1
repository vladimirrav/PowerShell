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
        # 2101
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
    [int]$interval = 5,
    [int]$bar_size = 60
);

<# For testing
    $start = (Get-Date).ToString('2023-05-08 09:00:00');
    $end = (Get-Date).ToString('2024-05-09 07:00:00');
    $bar_size = 60;
#>

$start = (!$start ? (Get-Date).ToString('2018-09-10 09:30:00') : $start);
$end = (!$end ? (Get-Date).ToString('2019-09-14 07:00:00') : $end);
$interval = (!$interval ? 7 : $interval);
$i = 1;
$qt_pad = 10;
$ch_pad = " ";
# $qt_min = 0;
# $qt_min_total = 0;
$n = $bar_size/100;
$ts = New-TimeSpan -Start $start -End $end;

do {
    Clear-Host;
    Write-Host ('-' * ((100 * $n) + 5));
    $ts2 = New-TimeSpan -Start (Get-Date) -End $end;
    $pc = 1 - $ts2.TotalMinutes / $ts.TotalMinutes;
    $ForegroundColor = 
        switch ([math]::Round($pc, 3)) {
            {$_ -ge 0 -and $_ -le 0.25} { 'DarkRed' }
            {$_ -gt 0.25 -and $_ -le 0.5} { 'DarkMagenta' }
            {$_ -gt 0.5 -and $_ -le 0.75} { 'DarkYellow' }
            {$_ -gt 0.75 -and $_ -le 1} { 'DarkGreen' }
            Default {'DarkBlue'}
        };
    Write-Host ([char]12321, (([char]9608).toString() * [Math]::Floor($pc * (100 * $n))).PadRight((100 * $n), ' '), [char]12321) ($pc).ToString('| 0.0% |') -ForegroundColor $ForegroundColor;
    $Host.UI.RawUI.WindowTitle = ([char]12321, (([char]9608).toString() * [Math]::Floor($pc * (100 * 0.50))).PadRight((100 * 0.50), ' '), [char]12321), ($pc).ToString('| 0.0% |')

    Write-Host ('-' * ((100 * $n) + 5));
    Write-Host ('#', $i);
    Write-Host ('Start'.PadRight($qt_pad, $ch_pad), $start);
    Write-Host ('End'.PadRight($qt_pad, $ch_pad), $end);
    Write-Host ('Interval'.PadRight($qt_pad, $ch_pad), [timespan]::FromSeconds($interval).toString());
    $ts.To
    Write-Host ('Days'.PadRight($qt_pad, $ch_pad), ([Math]::Ceiling($ts2.TotalDays)).ToString('0').PadLeft($qt_pad, $ch_pad), '|', ([Math]::Ceiling($ts.TotalDays)).ToString('0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Hours'.PadRight($qt_pad, $ch_pad), $ts2.TotalHours.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalHours.ToString('#,0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Minutes'.PadRight($qt_pad, $ch_pad), $ts2.TotalMinutes.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalMinutes.ToString('#,0').PadLeft($qt_pad, $ch_pad));
    Write-Host ('Seconds'.PadRight($qt_pad, $ch_pad), $ts2.TotalSeconds.ToString('#,0').PadLeft($qt_pad, $ch_pad), '|', $ts.TotalSeconds.ToString('#,0').PadLeft($qt_pad, $ch_pad));

    Write-Host ('-' * ((100 * $n) + 5));

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