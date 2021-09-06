<#
.SYNOPSIS
    Build de projeto SSIS
.DESCRIPTION
    Realização de build do projeto desenvolvido no SSIS com saída de arquivo ispac para deploy.
.PARAMETER Projeto
    Diretório de localização do projeto com apontamento para o arquivo projeto.sln
.PARAMETER exec_build
    Caminho do executável que efetua o build.
.INPUTS
    Diretório de localização do projeto;
    Versão do Visual Studio.
.OUTPUTS
    Arquivo <projeto>.ispac no diretório .\<Projeto>\bin\Development
.NOTES
    Version:        1.0
    Author:         Vladimir
    Creation Date:  13/02/2020
    Purpose/Change: Build de projetos
    Source:         https://github.com/bobduffyie/ssisTools
  
.EXAMPLE
    Set-Location -Path "C:\Users\vladimir.vargas\OneDrive\Documentos\Powershell_local"
    & '.\SSIS Build.ps1' -Projeto "C:\Users\vladimir.vargas\Documents\ETL\Projeto\Projeto.sln"
#>

# Import-Module SQLPS -DisableNameChecking
param (
    [string]$Projeto,
    [string]$exec_build = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.com"
)
$dt_inicio = Get-Date;

Write-Host ("Projeto: {0}" -f $Projeto);

$ispac = Invoke-Command -Command {& $exec_build "$Projeto" /Rebuild};
$dt_fim = Get-Date;

$ispac.SyncRoot | Select-Object -Last 1;

Write-Host "Tempo decorrido:" (New-TimeSpan -Start $dt_inicio -End $dt_fim);