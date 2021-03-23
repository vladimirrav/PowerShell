<#
    Script SQL gerado pelo PowerDesigner
    Ajuste nas criação das constraints
    Resultado final no console
    Operação manual, durante automatização do processo ocorre erro de index
        * Possivelmente não todos os scripts de constraint FK possuem a mesma estrutura de linhas
        * Alter table não pode ser a primeira linha da string
#>

Clear-Host;

# Write-Host "Ajuste na criação das constraints FK"

$documents = [Environment]::GetFolderPath("MyDocuments");
Set-Location -Path $documents;

$file = "$documents\DM01 - Criação de constraints.sql";
$str = @();
$str += Get-Content $file;

$schema_name = "sch_name";

$i = 0;
foreach ($s in $str)
{
    $tmp = $s;

    if($s -match 'create table ')
    {
        $s = "if object_id('" + ($s -replace 'create table ' -replace ' \(').Split('.')[0] + "." + ($s -replace 'create table ' -replace ' \(').Split('.')[1] + "') is null";
        $s += "`r`n" + $tmp;
    };

    $tmp = $str[$i - 0];
    if($s -match 'add constraint')
    {
        $s = ("if object_id('" + ($str[$i - 1] -replace 'alter table ').Substring(0, ($str[$i - 1] -replace 'alter table ').IndexOf('.')) + "." + $s.Substring($s.IndexOf('FK'), $s.IndexOf('foreign') - $s.IndexOf('FK')-1) + "') is null"); #Nome da FK
        $str[$i - 2] = $s;
    };

    if ($s.Contains("references Dim"))
    {
        $s = $s.Replace("references Dim", "references $schema_name.Dim");
    }
    elseif ($s.Contains("references Fat"))
    {
        $s = $s.Replace("references Fat", "references $schema_name.Fat");
    }
    elseif ($s.Contains("references Agr"))
    {
        $s = $s.Replace("references Agr", "references $schema_name.Agr");
    };

    $i++;
};

foreach($s in $str)
{
    Write-Host $s;
};
