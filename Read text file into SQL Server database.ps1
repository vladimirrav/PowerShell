Clear-Host;

$db_name = "db_name";
$sql_instance_name = "server";
$usr = Get-Content -Path ([Environment]::GetFolderPath("MyDocuments") + "\usr.txt") | Select-Object -First 1;
$pwd = Get-Content -Path ([Environment]::GetFolderPath("MyDocuments") + "\usr.txt") | Select-Object -Last 1;

$file_list = (Get-ChildItem -Path ([Environment]::GetFolderPath("MyDocuments") + "\CAIXA\SIDCE\ETL\Arquivos\Transmite")-Filter "*__038-TSE-*_ORIGEM_DESTINO.txt")

$cmd_ddl = "if object_id('compara_etl') is not null
	drop table compara_etl;

create table compara_etl
(
	NU_ID int identity(1, 1),
    DH_CADASTRO datetime default current_timestamp,
	BANCO_DADOS bit default 0
);

execute sp_addextendedproperty
	@name = N'MS_Description', @value = N'Teste de ETL a fim de verificar a identificação dos registros do arquivo ORIGEM_DESTINO.',
	@level0type = N'Schema', @level0name = N'dbo',
	@level1type = N'Table',  @level1name = N'compara_etl';";

Invoke-Sqlcmd -Database $db_name -Query $cmd_ddl -ServerInstance $sql_instance_name -Username $usr -Password $pwd;

Foreach ($file in $file_list)
{
    Write-Host (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") $file -ForegroundColor Yellow;
    $columns = (Get-Content -Path $file.FullName | Select -First 1).Replace("`t", ", ")
    $cmd_insert = "insert into compara_etl ($columns) values (";
    
    $rows = (Get-Content -Path $file.FullName | Select-Object -Skip 1).Replace("`t", "', '");
    Write-Host "Rows" $rows.Count.ToString('#,#');
    
    Foreach ($row in $rows)
    {
        $sql_statement = "$cmd_insert'$row');";
        Invoke-Sqlcmd -Database $db_name -Query $sql_statement -ServerInstance $sql_instance_name -Username $usr -Password $pwd;
        # Write-Host $sql_statement;
        # Break;
    };
    # Break;
};
