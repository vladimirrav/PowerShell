<#
	Cálculo de sobreaviso
	Date: 2023-11-04
	(New-TimeSpan -Start (Get-Date).ToString('yyyy-MM-dd 03:15') -End (Get-Date)).TotalMinutes
	(New-TimeSpan -Start '2023-11-05 02:20' -End '2023-11-05 06:00').TotalMinutes;
#>
Write-Host('Sobreaviso');
$bar_size = 100;
$n = $bar_size/100;
$vr = Get-Random -Minimum 5000 -Maximum 10000;
$vr_hr = [math]::Round($vr / 220, 2);

$start = (Get-Date).AddMinutes(0).ToString('2023-12-22 18:49');
$end = (Get-Date).AddDays(1).toString("2023-12-23 12:00");
$ts = New-TimeSpan -Start $start -End $end;

$hr_50 = [math]::Round($vr_hr * 1.5, 2);
$hr_100 = [math]::Round($vr_hr * 2, 2);
$hr_50_ad = [math]::Round($hr_50 * 1.2, 2);
$hr_100_ad = [math]::Round($hr_100 * 1.2, 2);
$hr_sa = [math]::Round($vr_hr / 3, 2);

$TotalHours = [math]::Round($ts.TotalHours, 2);

$hr_ac_50 = [math]::Round(
	(
		(New-TimeSpan -Start '2023-12-23 06:00' -End '2023-12-23 08:44').TotalMinutes +
		(New-TimeSpan -Start '2023-12-23 08:55' -End '2023-12-23 12:00').TotalMinutes
	) / 60, 2);
$hr_ac_100 = [math]::Round(0 / 60, 2);
# Adicional noturno
$hr_ac_50_ad = [math]::Round((New-TimeSpan -Start '2023-12-23 02:20' -End '2023-12-23 05:59').TotalMinutes / 60, 2);
$hr_ac_100_ad = [math]::Round(0 / 60, 2);
$hr_ac_tot = $hr_ac_50 + $hr_ac_100 + $hr_ac_50_ad + $hr_ac_100_ad;

$vr_ac_50 = [math]::Round($hr_ac_50 * $hr_50, 2);
$vr_ac_100 = [math]::Round($hr_ac_100 * $hr_100, 2);
$vr_ac_50_ad = [math]::Round($hr_ac_50_ad * $hr_50_ad, 2);
$vr_ac_100_ad = [math]::Round($hr_ac_100_ad * $hr_100_ad, 2);
$vr_ac_tot = [math]::Round($vr_ac_50 + $vr_ac_100 + $vr_ac_50_ad + $vr_ac_100_ad, 2);

# Deduzir acionamentos do sa
$vr_ac_sa = [math]::Round($hr_ac_tot * $hr_sa, 2);
$TotalHours_sa = $TotalHours - $hr_ac_tot;

$vr_sa_TotalHours = [math]::Round($TotalHours * $hr_sa, 2);
$vr_sa = [math]::Round($vr_sa_TotalHours - $vr_ac_sa, 2);

Write-Host('Start:', $start, (Get-Date $start).DayOfWeek);
Write-Host('End:', $end, (Get-Date $end).DayOfWeek);
Write-Host('TotalHours:', $TotalHours);
Write-Host('TotalMinutes:', $ts.TotalMinutes);
Write-Host('-' * 40);
Write-Host('Valor base:', $vr);
Write-Host('Valor hora normal:', $vr_hr);
Write-Host('Valor hora sa:', $hr_sa);
Write-Host('Valor hora 50%:', $hr_50);
Write-Host('Valor hora 100%:', $hr_100);
Write-Host('Valor hora 50% + 20%:', $hr_50_ad);
Write-Host('Valor hora 100% + 20%:', $hr_100_ad);
Write-Host('-' * 40);
Write-Host('Valor de sobreaviso total:', 'R$', $vr_sa_TotalHours);
Write-Host('Valor de sobreaviso considerado:', 'R$', $vr_sa);
Write-Host('-' * 40);
Write-Host('Horas de acionamento 50%:', $hr_ac_50);
Write-Host('Horas de acionamento 50% + 20%:', $hr_ac_50_ad);
Write-Host('Valor de acionamento 50%:', 'R$', $vr_ac_50);
Write-Host('Valor de acionamento 50% + 20%:', 'R$', $vr_ac_50_ad);
Write-Host('Horas de acionamento 100%:', $hr_ac_100);
Write-Host('Horas de acionamento 100% + 20%:', $hr_ac_100_ad);
Write-Host('Valor de acionamento 100%:', 'R$', $vr_ac_100);
Write-Host('Valor de acionamento 100% + 20%:', 'R$', $vr_ac_100_ad);
Write-Host('Horas de sobreaviso:', $TotalHours_sa);
Write-Host('Horas de acionamento:', $hr_ac_tot);
$str_len = (@('TotalHours', 'TotalHours_sa', 'hr_ac_tot', 'hr_ac_50', 'hr_ac_50_ad', 'hr_ac_100', 'hr_ac_100_ad') | Measure-Object -Maximum -Property Length).Maximum;
Write-Host((([char]9608).toString() * 2), 'TotalHours'.PadRight($str_len, ' '), "`t", $TotalHours.ToString().PadLeft(6, ' ')) -ForegroundColor White;
Write-Host((([char]9608).toString() * 2), 'TotalHours_sa'.PadRight($str_len, ' '), "`t", $TotalHours_sa.ToString().PadLeft(6, ' ')) -ForegroundColor DarkGray;
Write-Host((([char]9608).toString() * 2), 'hr_ac_tot'.PadRight($str_len, ' '), "`t", $hr_ac_tot.ToString().PadLeft(6, ' ')) -ForegroundColor Blue;
Write-Host((([char]9608).toString() * 2), 'hr_ac_50'.PadRight($str_len, ' '), "`t", $hr_ac_50.ToString().PadLeft(6, ' ')) -ForegroundColor DarkYellow;
Write-Host((([char]9608).toString() * 2), 'hr_ac_50_ad'.PadRight($str_len, ' '), "`t", $hr_ac_50_ad.ToString().PadLeft(6, ' ')) -ForegroundColor DarkMagenta;
Write-Host((([char]9608).toString() * 2), 'hr_ac_100'.PadRight($str_len, ' '), "`t", $hr_ac_100.ToString().PadLeft(6, ' ')) -ForegroundColor DarkGreen;
Write-Host((([char]9608).toString() * 2), 'hr_ac_100_ad'.PadRight($str_len, ' '), "`t", $hr_ac_100_ad.ToString().PadLeft(6, ' ')) -ForegroundColor Magenta;

Write-Host('Gráfico de sobreaviso e acionamento - Geral');
$pc = [math]::Round($TotalHours_sa / $TotalHours, 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkGray -NoNewline;
$pc = [math]::Round(($hr_ac_tot / $TotalHours), 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor Blue;

Write-Host('Gráfico de sobreaviso e acionamento - Detalhe');
$pc = [math]::Round($TotalHours_sa / $TotalHours, 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkGray -NoNewline;
$pc = [math]::Round(($hr_ac_50 / $TotalHours), 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkYellow -NoNewline;
$pc = [math]::Round(($hr_ac_50_ad / $TotalHours), 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkMagenta -NoNewline;
$pc = [math]::Round(($hr_ac_100 / $TotalHours), 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkGreen -NoNewline;
$pc = [math]::Round(($hr_ac_100_ad / $TotalHours), 3);
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor Magenta;

Write-Host('Gráfico acionamento - Detalhe');
$pc = if ($hr_ac_tot -eq 0) {0} else {[math]::Round(($hr_ac_50 / $hr_ac_tot), 3)};
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkYellow -NoNewline;
$pc = if ($hr_ac_tot -eq 0) {0} else {[math]::Round(($hr_ac_50_ad / $hr_ac_tot), 3)};
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkMagenta -NoNewline;
$pc = if ($hr_ac_tot -eq 0) {0} else {[math]::Round(($hr_ac_100 / $hr_ac_tot), 3)};
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor DarkGreen -NoNewline;
$pc = if ($hr_ac_tot -eq 0) {0} else {[math]::Round(($hr_ac_100_ad / $hr_ac_tot), 3)};
Write-Host (([char]9608).toString() * [Math]::Floor(($pc -le 1 ? $pc : 1) * (100 * $n))) -ForegroundColor Magenta;

Write-Host('-' * 40);
Write-Host('Valor total:', 'R$', ([math]::Round($vr_sa + $vr_ac_tot, 2))) -ForegroundColor Cyan;
Write-Host('-' * 40);
