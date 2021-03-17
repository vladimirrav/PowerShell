<#
    .SYNOPSIS
    Comprime arquivo.

    .DESCRIPTION
    Comprime arquivo e adiciona o arquivo atual ao arquivo já comprimido, caso exista.

    .PARAMETER guid
    Unique identifier.

    .PARAMETER diretorio_origem
    Diretório no qual se encontra o arquivo a ser comprimido.

    .PARAMETER diretorio_destino
    Diretório para o qual deve ser salvo o arquivo após compressão.

    .PARAMETER arquivo
    Nome do arquivo a ser comprimido.

    .OUTPUTS
    Arquivo comprimido no formato guid.zip

    .NOTES
        Author: Vladimir Rubinstein Andrade Vargas
        Date: 2021-03-16

    .EXAMPLE
    $directory = ([Environment]::GetFolderPath("MyDocuments"));
    & "$directory\Powershell_local\ComprimeArquivo.ps1" -guid "89E4A6D0-B2C1-495C-B7D5-1A8B4E6D0C2A" -diretorio_origem "$directory\Powershell" -diretorio_destino "$directory\Powershell" -arquivo "Github.ps1"
#>

param
(
    [string]$guid,
    [string]$diretorio_origem,
    [string]$diretorio_destino,
    [string]$arquivo
);

<# Teste --------------------------------------------------------
$directory = ([Environment]::GetFolderPath("MyDocuments"))

[string]$guid = (New-Guid).Guid.toString().toUpper()
[string]$diretorio_origem = "$directory\Powershell"
[string]$diretorio_destino = "$directory\Powershell"
[string]$arquivo = "Github.ps11"
#--------------------------------------------------------------#>

Clear-Host;
Set-Location $diretorio_origem;
Write-Host ('-' * 80);

$QtPad = 20;

Write-Host 'Comprime arquivo';
Write-Host ([char]11166)'guid:'.PadRight($QtPad, ' ') -NoNewline;
Write-Host $guid.Replace('{', '').Replace('}', '') -ForegroundColor Cyan;

Write-Host ([char]11166)'diretorio_origem:'.PadRight($QtPad, ' ') -NoNewline;
Write-Host $diretorio_origem -ForegroundColor Cyan;

Write-Host ([char]11166)'diretorio_destino:'.PadRight($QtPad, ' ') -NoNewline;
Write-Host $diretorio_destino -ForegroundColor Cyan;

Write-Host ([char]11166)'arquivo:'.PadRight($QtPad, ' ') -NoNewline;
Write-Host $arquivo -ForegroundColor Cyan;

Write-Host ('-' * 80);

$x = ($diretorio_origem + "\" + $arquivo).Replace("\\", "\");

try
{
    Compress-Archive -Update -Path ($x) -CompressionLevel Optimal -DestinationPath ($diretorio_destino + '\' + $guid) -ErrorAction Stop;
    Write-Host ([char]10004) 'Operação realizada com sucesso' -ForegroundColor Green;
}
catch
{
    Write-Host ([char]10006) $_.Exception.Message -ForegroundColor Red;
}
finally
{
    Write-Host("-" * 80)
};