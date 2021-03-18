<#
    .SYNOPSIS
    Verifica se CPF é válido

    .DESCRIPTION
    - Verificação da validade de um CPF;
    - 0 finaliza a execução.

    .PARAMETER cpf
    Número para a verificação.

    .PARAMETER sg
    Indica se deve ser usada a sigla da região ou o nome por extenso;
      -sg $true ou -sg 1 - Sigla da região;
      -sg $false ou -sg 0 - Nome da região fiscal escrita por extenso.

    .EXAMPLE
    & ((([Environment]::GetFolderPath("MyDocuments")), "PowerShell\Verifica CPF.ps1") -join "\") -cpf 12345678909

    .EXAMPLE
    & ((([Environment]::GetFolderPath("MyDocuments")), "PowerShell\Verifica CPF.ps1") -join "\") -cpf "123.456.789-09" -sg $false
#>
param
(
    [string]$cpf,
    [boolean]$sg = $true
);

Write-Host 'Verifica CPF';

$x = 1;

While($true)
{
    If([string]::IsNullOrEmpty($cpf))
    {
        [string]$cpf = (Read-Host -Prompt ($x.ToString() + ' CPF'))
    };

    If($cpf -eq '0')
    {
        '-' * 45;
        Break;
    };

    $str = ([bigint]($cpf -replace '[^0-9]')).ToString('0'*11);

    $i = 0;
    $soma = 0;
    $DG1 = 0;
    $DG2 = 0;
    $CPFTemp = 0;
    $digitosIguais = $true;
    $resultado = $false;
    $CPFTemp = $str.Substring($i,1);

    While($i -lt 11)
    {
        If($str.Substring($i,1) -ne $CPFTemp)
        {
            $digitosIguais = $false;
            Break;
        };
        $i = $i + 1;
    };

    If(!$digitosIguais)
    {
        $soma = 0;
        $i = 0;
    
        While ($i -le 8)
        {
            $soma = $soma + ([bigint]($str.Substring($i,1))) * (10 - $i);
            $i = $i + 1;
        };

        $DG1 = 11 - ($soma % 11)

        If($DG1 -gt 9)
        {
            $DG1 = 0;
        };

        $soma = 0;
        $i = 0;
        While($i -le 9)
        {
            $soma = $soma + ([bigint]($str.Substring($i,1)) * (11 - $i));
            $i = $i + 1
        };

        $DG2 = 11 - ($soma % 11);

        If($DG2 -gt 9)
        {
            $DG2 = 0;
        };

        If(($DG1 -eq $str.Substring($str.Length - 2,1)) -and ($DG2 -eq $str.Substring($str.Length - 1,1)))
        {
            $resultado = $true;
        }
        Else
        {
            $resultado = $false;
        };
    };

    If($resultado)
    {
        $ForegroundColor = 'Green';
        $char = [char]10004
    }
    Else
    {
        $ForegroundColor = 'Red'
        $char = [char]10006
    };

    Switch ($str.Substring(8,1))
    {
        0 {
            $regiao = '10. Rio Grande do Sul';
            $uf = '10. RS'
            }
        1 {
            $regiao = '1. Distrito Federal, Goiás, Mato Grosso, Mato Grosso do Sul e Tocantins';
            $uf = '1. DF, GO, MT, MS, TO'
            }
        2 {
            $regiao = '2. Amazonas, Pará, Roraima, Amapá, Acre e Rondônia';
            $uf = '2. AM, PA, RR, AP, AC, RO'
            }
        3 {
            $regiao = '3. Ceará, Maranhão e Piauí';
            $uf = '3. CE, MA, PI'
            }
        4 {
            $regiao = '4. Paraíba, Pernambuco, Alagoas e Rio Grande do Norte';
            $uf = '4. PB, PE, AL, RN'
            }
        5 {
            $regiao = '5. Bahia e Sergipe';
            $uf = '5. BA, SE'
            }
        6 {
            $regiao = '6. Minas Gerais';
            $uf = '6. MG'
            }
        7 {
            $regiao = '7. Rio de Janeiro e Espírito Santo';
            $uf = '7. RJ, ES'
            }
        8 {
            $regiao = '8. São Paulo';
            $uf = '8. SP'
            }
        9 {
            $regiao = '9. Paraná e Santa Catarina';
            $uf = '9. PR, SC'
            }
    };

    Write-Host $char, " " -ForegroundColor $ForegroundColor -NoNewline
    If ($sg)
    {
      $re = $uf;
      
    }
    Else
    {
      $re = $regiao;
    };

    Write-Host ($str.Substring(0,3), '.', $str.Substring(3,3), '.', $str.Substring(6,3), '-', $str.Substring(9,1), $str.Substring(10,1), '  ', $re) -Separator "";

    $x += 1;
    $cpf = $null;
};