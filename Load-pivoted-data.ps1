Clear-Host

$dt_start = Get-Date

Write-Host ("-" * 80)
Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Download data" -ForegroundColor Yellow
Write-Host ("-" * 80)

$elapsed_time = 0

$path = "C:\Users\Vladimir\OneDrive\Documentos\COVID-19\Dataset"
$date = (Get-Date).Date.AddDays(-1).ToString('MM-dd-yyyy')

$uri = @()
$uri += "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/$date.csv"
$uri += "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
$uri += "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
$uri += "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"

$date_ymd = (Get-Date).Date.AddDays($x).ToString('yyyy-MM-dd')

foreach($file in $uri)
{
    $outfile = ("$path\"+(Split-Path $file -Leaf)) -replace $date, ($date_ymd + "_csse_covid_19_daily_report")
    Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") "|" (Split-Path $outfile -Leaf)
    try {
        Invoke-WebRequest -Uri $file -OutFile $outfile
    }
    catch {
        Write-Host "    Error: $file" -ForegroundColor Red
    }
    #Start-Sleep -Milliseconds 1000
    $dt_end = Get-Date
    $elapsed_time += (New-TimeSpan -Start $dt_start -End $dt_end).TotalSeconds
    $ts = [timespan]::fromseconds($elapsed_time)
}

Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") "| Elapsed time:"("{0:hh\:mm\:ss\,fff}" -f $ts)
Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Download finished"

Write-Host ("-" * 80)
Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Load pivoted data" -ForegroundColor Yellow
Write-Host ("-" * 80)

$path = 'C:\Users\Vladimir\OneDrive\Documentos\COVID-19\Dataset\'
$items = (Get-ChildItem -Path ($path + "time_series*.csv") | Select-Object FullName) #| Select -First 1
$tables = @()

$items_count = $items.Count

$sql_instance_name = '.'
$db_name = 'COVID-19'

$i = 0

foreach ($item in $items)
{
    $i++

    $dt_start = Get-Date
    $file = (Split-Path -Path $item.FullName -Leaf)
    $schema = "stg"
    $table = $file.Split('.')[0]
    $table += '_pivot'
    $tables += "$table"
    Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| File: $file"
    Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Schema: [$schema]"
    Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Table: [$table]"
    
    $header = (Get-Content $item.FullName | Select-Object -First 1).replace(",", "|,|")

    $j = 0; $new_header = @();

    foreach ($column in $header.Replace('|', '').split(','))
    {
       $new_header += "Column_$j"
       $j++
    }
    
    $drop_table = "if (object_id('[$schema].[$table]')) is not null drop table $schema.[$table];"
    
    Invoke-Sqlcmd -Database $db_name -Query $drop_table -ServerInstance $sql_instance_name

    $create_table = ("if (object_id('[$schema].[$table]')) is null
    create table [$schema].[$table] (" +
    " id int identity constraint [pk_$schema_$table] primary key," +
    " [" + $header + "] varchar(500),`n`tload_date datetime`n);").Replace('|,|', "] varchar(500), [")
    
    Invoke-Sqlcmd -Database $db_name -Query $create_table -ServerInstance $sql_instance_name

    $csv = Import-Csv -Path $item.FullName -Header $new_header | Select-Object -Skip 1
    
    $insert = $null
    $pc_row = 0
    $r = 0
    $csv_count = $csv.Count
    foreach ($row in $csv)
    {
        $r++
        $pc_row = [math]::Round((($r / $csv_count) * 100), 1)
        Write-Progress -Activity ("$i/$items_count".PadRight(10, ' ') + "$file") -Status ("$pc_row%".PadRight(6, ' ') + " Complete") -PercentComplete $pc_row;

        $query = "insert into [$schema].[$table] values ("
        foreach ($column in $new_header)
        {
            $value = ($row | Select-Object $column)
            $query += "nullif('" + ($value | ForEach-Object { $_.$(( $value | Get-Member | Where-Object { $_.membertype -eq "noteproperty"} )[0].name) }).Replace("'", "''") + "',''),"
        }
        $query += " current_timestamp);"
        $insert = $query
        #Write-Host $row.Column_1

        Invoke-Sqlcmd -Database $db_name -Query $insert -ServerInstance $sql_instance_name
    }

    Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Lines: $csv_count"

    #Start-Sleep -Seconds 2

    $dt_end = Get-Date
    $elapsed_time += (New-TimeSpan -Start $dt_start -End $dt_end).TotalSeconds
    $ts = [timespan]::fromseconds($elapsed_time)

    Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") "| Elapsed time:"("{0:hh\:mm\:ss\,fff}" -f $ts)
    Write-Host ("-" * 80)
}

Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Unpivot data" -ForegroundColor Yellow
Write-Host ("-" * 80)

$i = 1
$qt_tables = $tables.Count
Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Tables: $qt_tables"

foreach ($table in $tables)
{
    $pivot_columns = "select
	    quotename(TABLE_SCHEMA) as table_schema,
	    quotename(TABLE_NAME) as table_name,
	    quotename(COLUMN_NAME) as column_name,
	    ORDINAL_POSITION
    from INFORMATION_SCHEMA.COLUMNS
    where quotename(TABLE_SCHEMA) = '[$schema]' and quotename(TABLE_NAME) = quotename('$table')
    order by ORDINAL_POSITION;"

    $columns = (Invoke-Sqlcmd -Database $db_name -Query $pivot_columns -ServerInstance $sql_instance_name).column_name | Select -Skip 5 | Select -SkipLast 1

    $column_list = $null

    foreach ($column in $columns)
    {
        $column_list += $column.ToString() + ","
    }

    $column_list = $column_list -replace '.$' -replace ',', ",`n`t`t"

    $unpivot_data = "select
	    convert(date, [date], 1) as [date],
	    [Province/State],
	    [Country/Region],
	    Lat,
	    Long,
	    cases,
        current_timestamp as load_date
    from
    (
	    select 
		    [Province/State],
		    [Country/Region],
		    Lat,
		    Long,
		    $column_list
	    from $schema.[$table]
    ) d
    unpivot
    (
	    cases
	    for date in ($column_list)
    ) unpiv;"

    $table = $table -replace '_pivot$', '_unpivot'
    
    Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "|"($i++)"/$qt_tables [$Schema].[$table]"

    $drop_table = "if (object_id('[$schema].[$table]')) is not null drop table $schema.[$table];"

    Invoke-Sqlcmd -Database $db_name -Query $drop_table -ServerInstance $sql_instance_name

    $create_table = "create table $schema.[$table]
    (
        id int identity constraint [pk_$schema_$table] primary key,
        [date] date,
	    [Province/State] nvarchar(100),
	    [Country/Region] nvarchar(100),
	    Lat decimal(20,15),
	    Long decimal(20,15),
	    cases int,
        load_date datetime
    );"

    Invoke-Sqlcmd -Database $db_name -Query $create_table -ServerInstance $sql_instance_name
    
    $insert_statement = "insert into [$schema].[$table]
    (
        [date],
	    [Province/State],
	    [Country/Region],
	    Lat,
	    Long,
	    cases,
        load_date
    )
    $unpivot_data"

    #$insert_statement
    
    Invoke-Sqlcmd -Database $db_name -Query $insert_statement -ServerInstance $sql_instance_name

    $elapsed_time += (New-TimeSpan -Start $dt_start -End $dt_end).TotalSeconds
    $ts = [timespan]::fromseconds($elapsed_time)
}
Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") "| Elapsed time:"("{0:hh\:mm\:ss\,fff}" -f $ts)
Write-Host (Get-Date -format "yyyy-MM-dd HH:mm:ss") "| Finish"