<#
    .SYNOPSIS
        SIMBA - Validador bancário

    .DESCRIPTION
        Linha de comando para execução do validador bancário do SIMBA
        com a quantidade especificada de memória.

    .OUTPUTS
        Execução da interface do validador.
#>
Write-Host "Executável do validador SIMBA" -ForegroundColor Yellow;

$simba = ([Environment]::GetFolderPath("MyDocuments") + '\Programas SIMBA\Validador');
Set-Location -Path $simba;

Write-Host "Execução do validador" -ForegroundColor Yellow;

java -Xmx8g -jar simba-validador.jar;