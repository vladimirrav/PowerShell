<#
    .SYNOPSIS
    Ajuste na sintaxe dos comandos sp_dropextendedproperty e sp_addextendedproperty do SQL Server

    .DESCRIPTION
    Ajuste nos scripts de criação e de exclusão das propriedades extendidas do SQL Server no arquivo SQL gerado pelo PowerDesigner.

    .INPUTS
        execute sp_dropextendedproperty 'MS_Description', 
        'user', 'Schema name', 'table', 'Table name', 'column', 'Column name'

        execute sp_addextendedproperty 'MS_Description', 
        'Object description.',
        'user', 'Schema name', 'table', 'Table name', 'column', 'Column name'

    .OUTPUTS
        execute sp_dropextendedproperty
            @name = N'MS_Description', 
            @level0type = N'schema', @level0name = N'Schema name',
            @level1type = N'table', @level1name = N'Table name',
            @level2type = N'column', @level2name = N'Column name' (if column of a table)
    
        execute sp_addextendedproperty
            @name = N'MS_Description', 
            @value = N'Object description.',
            @level0type = N'schema', @level0name = N'Schema name',
            @level1type = N'table', @level1name = N'Table name',
            @level2type = N'column', @level2name = N'Column name' (if column of a table)
    .EXAMPLE
        $p = @()
        $p += "C:\Users\vladimirvargas\Documents\ANEEL\Perdas técnicas\Modelo de dados\SQL"
        $p += "C:\Users\vladimirvargas\Documents\ANEEL\Custo operacional\Modelo de dados\SQL"
        & "C:\Users\vladimirvargas\Documents\PowerShell\PowerDesigner - SQL Server extended_properties.ps1" -path = $p
#>

Clear-Host

$sufix = " PS"
$db_name = "db_name"

$documents = [Environment]::GetFolderPath("MyDocuments")
Set-Location -Path $documents

$path = @()

<# DM 01 #>
$path += "$documents\DM 01\Modelo de dados\SQL"
<# DM 02 #>
# $path += "$documents\DM 02\Modelo de dados\SQL"

foreach ($folder in $path) {

    if ($folder[-1] -ne "\") {
        $folder += "\"
    }

    Set-Location -Path $folder

    $files = Get-ChildItem ($folder + "*.sql") -Exclude ("*$sufix.sql")

    foreach ($file in $files) {
        $test_path = Test-Path -Path ($folder + ((Split-Path $file -Leaf) -replace '.sql', ($sufix + '.sql')))
    
        if($test_path) {
            Remove-Item ($folder + ((Split-Path $file -Leaf) -replace '.sql', ($sufix + '.sql')))
        }
        $lines = @()
        $lines += "print '" + ((Split-Path $file -Leaf) -replace '.sql', ($sufix + '.sql')) + "';"
        $lines += ""
        $lines += "use $db_name;"
        $lines += ""
        $lines += Get-Content $file

        $i = 0
        Write-Host $file -ForegroundColor Yellow

        $tmp = $null
        foreach ($line in $lines) {
            $tmp = $line
            if($line -match 'create table ') {
                $line = "if object_id('" + ($line -replace 'create table ' -replace ' \(').Split('.')[0] + "." + ($line -replace 'create table ' -replace ' \(').Split('.')[1] + "') is null"
                $line += "`r`n" + $tmp
            }
            if ($lines[$i - 1] -like "*sp_addextendedproperty*") {
                $line = ($line.Trim() -replace "^'", "`t@value = N'").TrimEnd()
            }
            if ($line -like "*sp_addextendedproperty '*") {
                $line = $line.Replace("sp_addextendedproperty '", "sp_addextendedproperty`r`n`t@name = N'")
            }
            if ($line -like "*sp_dropextendedproperty '*") {
                $line = $line.Replace("sp_dropextendedproperty '", "sp_dropextendedproperty`r`n`t@name = N'")
            }
            if ($line -like "*'user', '*") {
                $line = $line.Replace("'user', '", "`t@level0type = N'schema', @level0name = N'")
            }
            if ($line -like "*'table', '*") {
                $line = $line.Replace("'table', '", "`r`n`t@level1type = N'table', @level1name = N'")
            }
            if ($line -like "*'column', '*") {
                $line = $line.Replace("'column', '", "`r`n`t@level2type = N'column', @level2name = N'")
            }
            if ($line.StartsWith("drop schema") -or $line.StartsWith("create schema") -or $line.StartsWith("drop user") -or $line.StartsWith("create user") ) {
                $line = $line -replace "^", "--"
            }
            if ($line.StartsWith('Add comment') -or $lines[$i - 1].StartsWith('Add comment') -or $line.StartsWith('execute sp_grantdbaccess')) {
                $line = $line -replace "^", "--"
            }
            if ($line.Contains('exists (select 1') -or $line.Contains('exists(select 1')) {
                $line = $line.Replace("exists (select 1", "exists (select *").Replace("exists(select 1", "exists (select *")
            }

            $i++
            #Write-Host $line
        
            $line | Out-File -Append ($folder + ((Split-Path $file -Leaf) -replace '.sql', ($sufix + '.sql')))
        }
    }
}