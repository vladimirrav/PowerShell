<#
    Set-Location -path "C:\Users\vladi\OneDrive\Documentos\COVID-19\Script"
    .\Estacao-ano.ps1
    & "C:\Users\vladi\OneDrive\Documentos\COVID-19\Script\Estacao-ano.ps1"
#>

Clear-Host

$Host.UI.RawUI.WindowTitle = 'Data das estações do ano - Histórico';

$db_name = 'COVID-19'
$sql_instance_name = '.'

$estacao = @('Outono', 'Inverno', 'Primavera', 'Verão')

$dt  = ('2005-03-20', '2005-06-21', '2005-09-22', '2005-12-21')
$dt += ('2006-03-20', '2006-06-21', '2006-09-23', '2006-12-21')
$dt += ('2007-03-20', '2007-06-21', '2007-09-23', '2007-12-22')
$dt += ('2008-03-20', '2008-06-20', '2008-09-22', '2008-12-21')
$dt += ('2009-03-20', '2009-06-21', '2009-09-22', '2009-12-21')
$dt += ('2010-03-20', '2010-06-21', '2010-09-23', '2010-12-21')
$dt += ('2011-03-20', '2011-06-21', '2011-09-23', '2011-12-22')
$dt += ('2012-03-20', '2012-06-20', '2012-09-22', '2012-12-21')
$dt += ('2013-03-20', '2013-06-21', '2013-09-22', '2013-12-21')
$dt += ('2014-03-20', '2014-06-21', '2014-09-23', '2014-12-20')
$dt += ('2015-03-20', '2015-06-21', '2015-09-23', '2015-12-22')
$dt += ('2016-03-20', '2016-06-20', '2016-09-22', '2016-12-21')
$dt += ('2017-03-20', '2017-06-21', '2017-09-22', '2017-12-21')
$dt += ('2018-03-20', '2018-06-21', '2018-09-22', '2018-12-21')
$dt += ('2019-03-20', '2019-06-21', '2019-09-23', '2019-12-22')
$dt += ('2020-03-20', '2020-06-20', '2020-09-22', '2020-12-21')

$sql_statement = @('truncate table stg.estacao_ano;');

$i = 0
foreach ($d in $dt) {
    $d_ini = [datetime]::parseexact($d, 'yyyy-MM-dd', $null)
    $d_fim = try {
        [datetime]::parseexact($dt[$i+1], 'yyyy-MM-dd', $null).AddDays(-1)
    } catch {
        $d_ini.AddDays(89)
    }
    
    $st_hemisferio_sul = Switch ($d_ini.Date.Month)
    {
        03 {$estacao[0]}
        06 {$estacao[1]}
        09 {$estacao[2]}
        12 {$estacao[3]}
    }
    $st_hemisferio_norte = Switch ($d_ini.Date.Month)
    {
        03 {$estacao[2]}
        06 {$estacao[3]}
        09 {$estacao[0]}
        12 {$estacao[1]}
    }
    # Write-Host ($d_ini.Date.ToString('yyyy-MM-dd') + ' - ' + $d_fim.Date.ToString('yyyy-MM-dd') + ("`t" * 2) + $st_hemisferio_sul.PadRight(9, ' ') + " | " + $st_hemisferio_norte)
    
    $sql_statement += ("insert into stg.estacao_ano (data_inicio, data_fim, estacao_hemisferio_norte, estacao_hemisferio_sul, load_date) values (" + $d_ini.Date.ToString('yyyyMMdd') + ", " + $d_fim.Date.ToString('yyyyMMdd') + ", '$st_hemisferio_norte', '$st_hemisferio_sul', current_timestamp);")

    # $d.GetType()
    # Break
    $i++
}
$sql_statement.GetType()
foreach ($st in $sql_statement){
    Write-Host $st
    Invoke-Sqlcmd -Database $db_name -Query $st -ServerInstance $sql_instance_name
}
