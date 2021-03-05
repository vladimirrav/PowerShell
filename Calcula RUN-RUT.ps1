<#
    .SYNOPSIS
    Cálculo del dígito del RUN/RUT

    .DESCRIPTION
    Calcula el dígito del número RUN/RUT.

    .PARAMETER Rut
    Número para o cálculo del dígito.

    .EXAMPLE
    & 'C:\Users\vladi\OneDrive\Documentos\Powershell\Calcula RUN-RUT.ps1' -Rut 1234567;
#>

param
(
    [string]$Rut
);

# $Rut = 1234567;

Write-Host 'Chile - Cálculo de RUT/RUN';
$x = 1;

While($true)
{
    if([string]::IsNullOrEmpty($Rut))
    {
        [string]$Rut = (Read-Host -Prompt ($x.ToString() + ' RUT'))
    } else {
        Write-Host ($x.ToString() + ' RUT: ' + $Rut);
    };

    $Rut = $Rut -replace '[^0-9]';

    if([int]$Rut -eq 0)
    {
        '-' * 45;
        Break;
    };

    [int]$Digito = $null;
    [int]$Contador = 2;
    [int]$Multiplo = $null;
    [int]$Acumulador = 0;
    [string]$retorno = $null;
    [int]$CalcRUT = $Rut;

    while ($CalcRUT -ne 0)
    {
	    $Multiplo = ($CalcRUT % 10) * $Contador;
	    $Acumulador = $Acumulador + $Multiplo;
        $CalcRUT = [Math]::Truncate($CalcRUT / 10);
	    $Contador = $Contador + 1;
	    if ($Contador -gt 7) {
            $Contador = 2;
        }
    
    };

    $Digito = 11 - ($Acumulador % 11);

    $retorno = Switch($Digito)
    {
        10 {'K'}
        11 {'0'}
        default{$Digito}
    }

    Write-host ((" " * ($x.ToString().Length + 1)) + ([int]$Rut).ToString('00,000,000') + "-" + $retorno);
    Write-Host;
    $Rut = $null;
    $x++;
};
