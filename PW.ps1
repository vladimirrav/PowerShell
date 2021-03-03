<#
    .SYNOPSIS
    Cálculo de consumo de equipamentos elétricos

    .DESCRIPTION
    Cálculo de consumo de equipamentos elétricos ao longo da vida útil em horas, quantidade de horas/dia de funcionamento e valor do kW/h.

    .PARAMETER valor_kwh
    Preço do kW/h em Reais (R$).

    .PARAMETER potencia_w
    Potência em Watts (W).

    .PARAMETER vida_util_h
    Vida útil em horas.

    .PARAMETER horas_dia
    Quantidade de horas de funcionamento por dia.

    .PARAMETER qt
    Quantidade de equipamentos.

    .PARAMETER qt_pad
    Quantidade de caracteres para o parâmetro pad para formatação da exibição da tabela.

    .PARAMETER ch_pad
    Caractere utilizado par a formatação da exibição da tabela.

    .OUTPUTS
    System.String. Add-Extension returns a string with the extension or file name.

    .EXAMPLE
    & 'C:\Users\vladi\OneDrive\Documentos\Shell\PW.ps1' -valor_kwh 0.905 -vida_util_h 25000 -horas_dia 8 -potencia_w 18 -qt 1
#>

param
(
    [decimal]$valor_kwh,
    [decimal]$potencia_w,
    [int]$vida_util_h,
    [decimal]$horas_dia,
    [int]$qt,
    [int]$qt_pad = 13,
    [string]$ch_pad = " "
);

$t_dia = $vida_util_h / $horas_dia;
$t_mes = $vida_util_h / $horas_dia / 30;
$t_ano = $vida_util_h / $horas_dia / 365;

$pwt = ($potencia_w * $qt * $vida_util_h) / 1000;
$vr_total = $potencia_w * $vida_util_h * $qt * ($valor_kwh)/1000;
$vr_dia = $potencia_w * $qt * $horas_dia * ($valor_kwh/1000);
$vr_mes = $potencia_w * $qt * 30 * $horas_dia * ($valor_kwh/1000);
$vr_ano = $potencia_w * $qt * 365 * $horas_dia * ($valor_kwh/1000);

$pw_dia = $potencia_w * $horas_dia / 1000;
$pw_mes = $potencia_w * $horas_dia / 1000 * 30;
$pw_ano = $potencia_w * $horas_dia / 1000 * 365;

$h_dia = $horas_dia;
$h_mes = $horas_dia * 30;
$h_ano = $horas_dia * 365;

Clear-Host;

'-' * 40

'{0,-25}{1,5}' -f 'Valor do kW/h:', '{0:C}' -f $valor_kwh;
'{0,-25}{1,7}{2,2}' -f 'Potência:', ("{0:n1}" -f $potencia_w),'W';
'{0,-25}{1,7}{2,2}' -f 'Vida útil:', ("{0:n0}" -f $vida_util_h), 'h';
'{0,-25}{1,7}{2,6}' -f 'Tempo de funcionamento:', $horas_dia, 'h/dia';
'{0,-25}{1,7}' -f 'Quantidade:', $qt;

' ' * 60;
'-' * 69;
("").PadRight($qt_pad, $ch_pad)     + '|' + ('Tempo').PadLeft($qt_pad, $ch_pad)              + '|' + ('R$').PadLeft($qt_pad, $ch_pad)                    + '|' + ' KW/h'.PadLeft($qt_pad, $ch_pad)              + '|' + (" Horas").PadLeft($qt_pad, $ch_pad)
'-' * 69;
("Dia").PadRight($qt_pad, $ch_pad)  + '|' + ("{0:n0}" -f ($t_dia)).PadLeft($qt_pad, $ch_pad) + '|' + (" {0:n2}" -f $vr_dia).PadLeft($qt_pad, $ch_pad)   + '|' + (" {0:n3}" -f $pw_dia).PadLeft($qt_pad, $ch_pad) + '|' + (" {0:n2}" -f $h_dia).PadLeft($qt_pad, $ch_pad);
("Mês").PadRight($qt_pad, $ch_pad)  + '|' + ("{0:n1}" -f $t_mes).PadLeft($qt_pad, $ch_pad) + '|' + (" {0:n2}" -f $vr_mes).PadLeft($qt_pad, $ch_pad)   + '|' + (" {0:n3}" -f $pw_mes).PadLeft($qt_pad, $ch_pad) + '|' + (" {0:n2}" -f $h_mes).PadLeft($qt_pad, $ch_pad);
("Ano").PadRight($qt_pad, $ch_pad)  + '|' + ("{0:n1}" -f $t_ano).PadLeft($qt_pad, $ch_pad) + '|' + (" {0:n2}" -f $vr_ano).PadLeft($qt_pad, $ch_pad)   + '|' + (" {0:n3}" -f $pw_ano).PadLeft($qt_pad, $ch_pad) + '|' + (" {0:n2}" -f $h_ano).PadLeft($qt_pad, $ch_pad);
'-' * 69;
("Total").PadRight($qt_pad, $ch_pad) + '|' + ("").PadLeft($qt_pad, $ch_pad)    + "|" + (" {0:n2}" -f $vr_total).PadLeft($qt_pad, $ch_pad) + '|'+ (" {0:n3}" -f $pwt).PadLeft($qt_pad, $ch_pad)                  + '|' + ("{0:n0}" -f $vida_util_h).PadLeft($qt_pad, $ch_pad);
'-' * 69;
' ' * 60;