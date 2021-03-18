<#
    .SYNOPSIS
    Cálculo de medidas equivalentes de pneu.

    .DESCRIPTION
    Calcula a medida equivalente para pneu de aros distintos com tolerância de 3%.

    .PARAMETER aro_inicial
    Medida do aro original do pneu em polegadas.

    .PARAMETER largura_inicial
    Medida da largura original do pneu em mm.

    .PARAMETER rel_largura_inicial
    Relação entre algura e largura do pneu.

    .EXAMPLE
    & 'C:\Users\vladi\OneDrive\Documentos\Powershell\Equivalencia de medidas de roda.ps1' -aro_inicial 14 -largura_inicial 175 -rel_largura_inicial 65;

    .NOTES
        Author:         Vladimir Rubinstein Andrade Vargas
        Creation Date:  2020-09-09
        Source of the information: http://www.kr-wheels.com/kr-wheels/site/docs/Conjunto-roda%20pneu-KR-Wheels.pdf
#>

param(
    [int]$aro_inicial,
    [int]$largura_inicial,
    [int]$rel_largura_inicial
);

# $aro_inicial = 14
# $largura_inicial = 175
# $rel_largura_inicial = 65

$diametro_inicial = [Math]::Round(($aro_inicial + (2 * ($largura_inicial * $rel_largura_inicial / 100) / 25.4)) * 25.4, 1);

$aro = $aro_inicial;
$largura = $largura_inicial;
$rel_largura = $rel_largura_inicial;


$diametro = $diametro_inicial;
$tolerancia = @($null, $null);
$tolerancia[0] = [math]::Round($diametro * 0.97, 1);
$tolerancia[1] = [math]::Round($diametro * 1.03, 1);

Clear-Host;
Write-Host "Equivalencia de medidas".ToUpper();
Write-Host "Aro original: $aro_inicial";
Write-Host "Diâmetro original:", ([Math]::Round($diametro_inicial)), "mm";
Write-Host "Diâmetro mímino:", ([Math]::Round(($tolerancia | Sort-Object | Select-Object -First 1), 0)), "mm";
Write-Host "Diâmetro máximo:", ([Math]::Round(($tolerancia | Sort-Object | Select-Object -Last 1), 0)), "mm";
Write-Host;

Write-Host "Tamanho".PadRight(6, ' ').PadLeft(16, ' '), "| Altura (mm)".PadRight(12, ' '), "| Diâmetro (mm)".PadRight(15, ' '), "| Circunferência (mm)".PadRight(20, ' ');
While ($aro -le 16)
{
    $largura = $largura_inicial;

    Write-Host "Aro $aro".ToUpper() -ForegroundColor Yellow;
    While ($largura -le 195)
    {
        $rel_largura = 70 #$rel_largura_inicial;
        
        While ($rel_largura -ge 25)
        {
            $diametro = ($aro + (2 * ($largura * $rel_largura / 100) / 25.4)) * 25.4;
            
            if (($diametro -ge $tolerancia[0]) -and ($diametro -le $tolerancia[1]))
            {
                $ForegroundColor = "Green";
                $char = [char]10004;
            
                Write-Host "`t$char $largura/$rel_largura R$aro".PadRight(13, ' ') -NoNewline -ForegroundColor $ForegroundColor;
                Write-Host ([Math]::Round($largura * $rel_largura / 100, 0)).ToString().PadLeft(15, ' ') -NoNewline -ForegroundColor $ForegroundColor;
                Write-Host " |", ([Math]::Round($diametro, 0)).ToString().PadLeft(13, ' ') -NoNewline -ForegroundColor $ForegroundColor;
                Write-Host " |", ('{0:N0}' -f [Math]::Round($diametro * [math]::PI, 0)).ToString().PadLeft(18, ' ') -NoNewline -ForegroundColor $ForegroundColor;
                Write-Host (&{If($aro -eq $aro_inicial -and $diametro -eq $diametro_inicial -and $rel_largura -eq $rel_largura_inicial) { ([char]9873).ToString().PadLeft(3, ' ') }}) -ForegroundColor Yellow;
            }
            else
            {
                $ForegroundColor = "Red";
                $char = [char]10006;
            }

            $rel_largura = $rel_largura - 5;
    
            if ($rel_largura -lt 40)
            {
                Break;
            }
        }
        $largura = $largura + 10;
    }
    $aro++;
};