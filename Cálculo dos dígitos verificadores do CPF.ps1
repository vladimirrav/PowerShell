<#
    .SYNOPSIS
    Cálculo dos dígitos verificadores do CPF.

    .DESCRIPTION
    - Cálculo dos dois dígitos verificadores para um CPF;
    - 0 para finalizar a execução após a primeira execução.

    .PARAMETER cpf
    Nove primeiros dígitos do CPF para o cálculo dos dígitos verificadores.
    Se for informada quantidade menor que 9 dígitos os restantes são preenchidos com zero à esquerda.

    .PARAMETER sg
    Indica se deve ser usada a sigla da região fiscal ou o nome por extenso;
      -sg $true ou -sg 1 - Sigla da região;
      -sg $false ou -sg 0 - Nome da região escrito por extenso.

    .NOTES
      Author: Vladimir Rubinstein Andrade Vargas

    .EXAMPLE
    & ((([Environment]::GetFolderPath("MyDocuments")), "PowerShell\Cálculo dos dígitos verificadores do CPF.ps1") -join "\") -cpf 123456789

    .EXAMPLE
    & ((([Environment]::GetFolderPath("MyDocuments")), "PowerShell\Cálculo dos dígitos verificadores do CPF.ps1") -join "\") -cpf 123456789 -sg $false
#>

param
(
    [string]$cpf,
    [boolean]$sg = $true
);

Write-Host 'Cálculo dos dígitos verificadores do CPF';

$x = 1;

while ($true)
{
    if([string]::IsNullOrEmpty($cpf))
    {
        [string]$cpf = (Read-Host -Prompt ($x.ToString() + ' CPF'))
    };

    if($cpf -eq '0')
    {
        '-' * 45;
        Break;
    };

    $str = ([bigint]($cpf -replace '[^0-9]')).ToString('0'*9);

    $a = $str.Substring(0, 1);
    $b = $str.Substring(1, 1);
    $c = $str.Substring(2, 1);
    $d = $str.Substring(3, 1);
    $e = $str.Substring(4, 1);
    $f = $str.Substring(5, 1);
    $g = $str.Substring(6, 1);
    $h = $str.Substring(7, 1);
    $i = $str.Substring(8, 1);
    $j = '';
    $k = '';

    Switch
    (
        (
            (10 * $a) +
            (09 * $b) +
            (08 * $c) +
            (07 * $d) +
            (06 * $e) +
            (05 * $f) +
            (04 * $g) +
            (03 * $h) +
            (02 * $i)
        ) % 11
    )
    {
        0 { $j = 0 }
        1 { $j = 0 }
        default
        {
            $j = 11 -
                    (
		                (
			                (10 * $a) +
			                (09 * $b) +
			                (08 * $c) +
			                (07 * $d) +
			                (06 * $e) +
			                (05 * $f) +
			                (04 * $g) +
			                (03 * $h) +
			                (02 * $i)
		                ) % 11
                    )
        }
    };

    Switch
    (
        (
	        (11 * $a) +
	        (10 * $b) +
	        (09 * $c) +
	        (08 * $d) +
	        (07 * $e) +
	        (06 * $f) +
	        (05 * $g) +
	        (04 * $h) +
	        (03 * $i) +
	        (02 * $j)
        ) % 11
    )
    {
        0 { $k = 0 }
        1 { $k = 0 }
        default
        {
            $k = 11 - (
		    	        (
				            (11 * $a) +
				            (10 * $b) +
				            (09 * $c) +
				            (08 * $d) +
				            (07 * $e) +
				            (06 * $f) +
				            (05 * $g) +
				            (04 * $h) +
				            (03 * $i) +
				            (02 * $j)
			            ) % 11
                    )
        }
    };

    Switch ($str.Substring(8,1))
    {
        0 {
            $regiao, $uf = '10. Rio Grande do Sul', '10. RS';
          }
        1 {
            $regiao, $uf = '1. Distrito Federal, Goiás, Mato Grosso, Mato Grosso do Sul e Tocantins', '1. DF, GO, MT, MS, TO';
          }
        2 {
            $regiao, $uf = '2. Amazonas, Pará, Roraima, Amapá, Acre e Rondônia', '2. AM, PA, RR, AP, AC, RO';
          }
        3 {
            $regiao, $uf = '3. Ceará, Maranhão e Piauí', '3. CE, MA, PI';
          }
        4 {
            $regiao, $uf = '4. Paraíba, Pernambuco, Alagoas e Rio Grande do Norte', '4. PB, PE, AL, RN';
          }
        5 {
            $regiao, $uf = '5. Bahia e Sergipe', '5. BA, SE';
          }
        6 {
            $regiao, $uf = '6. Minas Gerais', '6. MG';
          }
        7 {
            $regiao, $uf = '7. Rio de Janeiro e Espírito Santo', '7. RJ, ES';
          }
        8 {
            $regiao, $uf = '8. São Paulo', '8. SP';
          }
        9 {
            $regiao, $uf = '9. Paraná e Santa Catarina', '9. PR, SC';
          }
    };

    if ($sg)
    {
      $re = $uf;
      
    }
    else
    {
      $re = $regiao;
    };

    Write-Host ($str.Substring(0,3), '.', $str.Substring(3,3), '.', $str.Substring(6,3), '-', $j, $k, '  ', $re) -Separator "";

    $x += 1;
    $cpf = $null;
};