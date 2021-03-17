<#
    .SYNOPSIS
        Execução de scripts SQL.
    .DESCRIPTION
        Execução de scripts SQL que são passados via parâmetro.
    .PARAMETER no_servidor
        Servidor do SQL Server
    .PARAMETER no_bd
        Banco de dados
    .PARAMETER no_arquivo_sql
        Nome do arquivo a ser executado
    .INPUTS
        Script SQL
    .OUTPUTS
        Mensagem de sucesso ou de erro
    .NOTES
        Author:         Vladimir Rubinstein Andrade Vargas
        Creation Date:  2020-06-22
    .EXAMPLE
        & "\\<path>\PS_Executa_SQL.ps1" -no_servidor "server_name" -no_bd "db_name" -no_arquivo_sql "\\<path>\script.sql"
#>

param (
    [string] $no_servidor = "@{no_servidor}",
    [string] $no_bd = "@{no_bd}",
    [string] $no_arquivo_sql = "@{no_arquivo_sql}"
)

Write-Host ("Diretório: ".PadRight(12, ' ') + (Split-Path $no_arquivo_sql -Parent))
Write-Host ("Script SQL: ".PadRight(12, ' ') + (Split-Path $no_arquivo_sql -Leaf))
Get-Content $no_arquivo_sql | Measure-Object | ForEach-Object { $qt_linhas = $_.Count }

Write-Host "Linhas: $qt_linhas"
$batches = (Get-Content -LiteralPath $no_arquivo_sql -Raw) -split ("`r`nGO`r`n")

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server=$no_servidor;Database=$no_bd;Trusted_Connection=True;Encrypt=False;Connection Timeout=30;"

try
{
    $SqlConnection.Open()
    ($qt, $i) = ($batches.Count, 1)

    foreach($batch in $batches)
    {
        if ($batch.Trim() -ne ""){
            $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
            $SqlCmd.CommandText = $batch
            $SqlCmd.Connection = $SqlConnection
            $SqlCmd.ExecuteNonQuery() | Out-Null
        }
    }
    Write-Host "OK - Arquivo" (Split-Path $no_arquivo_sql -Leaf) "executado com sucesso" -ForegroundColor Green
}
catch
{
    Write-Host "ERRO - Falha na implantação do arquivo" (Split-Path $no_arquivo_sql -Leaf) -ForegroundColor Red
    $_.Exception.Message
}
finally
{
    $SqlConnection.Close()
}