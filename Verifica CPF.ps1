<#
    .SYNOPSIS
    Verifica se CPF é válido

    .DESCRIPTION
    - Verificação da validade de um CPF;
    - 0 finaliza a execução.

    .PARAMETER cpf
    Número para a verificação.

    .EXAMPLE
    & 'C:\Users\vladi\OneDrive\Documentos\Shell\Verifica CPF.ps1' -cpf 12345678909
#>
param
(
    [string]$cpf
);

Write-Host 'Verifica CPF';

$sg = $true;

#$ErrorActionPreference = "silentlycontinue";

$x = 1;

While($true)
{
    If([string]::IsNullOrEmpty($cpf))
    {
        [string]$cpf = (Read-Host -Prompt ($x.ToString() + ' CPF'))
    };

    if($cpf -eq '0')
    {
        '-' * 45;
        Break;
    };

    $str = ([bigint]($cpf -replace '[^0-9]')).ToString('0'*11);

    $indice = 0;
    $soma = 0;
    $DG1 = 0;
    $DG2 = 0;
    $CPFTemp = 0;
    $digitosIguais = $true;
    $resultado = $false;
    $CPFTemp = $str.Substring($indice,1);

    While($indice -lt 11)
    {
        If($str.Substring($indice,1) -ne $CPFTemp)
        {
            $digitosIguais = $false;
            Break;
        };
        $indice = $indice + 1;
    };

    If(!$digitosIguais)
    {
        $soma = 0;
        $indice = 0;
    
        While ($indice -le 8)
        {
            $soma = $soma + ([bigint]($str.Substring($indice,1))) * (10 - $indice);
            $indice = $indice + 1;
        };

        $DG1 = 11 - ($soma % 11)

        If($DG1 -gt 9)
        {
            $DG1 = 0;
        };

        $soma = 0;
        $indice = 0;
        While($indice -le 9)
        {
            $soma = $soma + ([bigint]($str.Substring($indice,1)) * (11 - $indice));
            $indice = $indice + 1
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
        $validade = 'Válido';
        $ForegroundColor = 'Green';
        $char = [char]10004
    }
    Else
    {
        $validade = 'Inválido';
        $ForegroundColor = 'Red'
        $char = [char]10006
        #'-' * 25
        #Break;
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

    Write-Host $char -ForegroundColor $ForegroundColor -NoNewline
    Write-Host (' ' + $str.Substring(0,3) + '.' + $str.Substring(3,3) + '.' + $str.Substring(6,3) + '-' + $str.Substring(9,1) + $str.Substring(10,1) + '  ') -NoNewline
    #Write-Host $validade -NoNewline -ForegroundColor $ForegroundColor
    Write-Host ('  ' + $uf);

    #If(!$sg)
    #{
    #    '-' * $regiao.Length;
    #    $regiao;
    #    '-' * $regiao.Length;
    #}
    #else
    #{
    #    '-' * $uf.Length;
    #    $uf;
    #    '-' * $uf.Length;
    #};
    $x += 1;
    $cpf = $null;
};