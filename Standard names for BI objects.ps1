<#
	Standard names for BI objects
#>

$object_type = @('job', 'table', 'extract');
$table_prefix = @('DM', 'BT', 'LK') | Sort-Object;
$table_type = 'DM';
$job_prefix = @('BQ');
$business_prefix = 'MR';
$extract_prefix = @('HYPER');
$obj_name = 'OBJECT_NAME';

foreach ($item in $object_type)
{
	Write-Host "$item`t" -NoNewline;
	if ($item -eq 'job')
	{
		foreach ($prefix in $job_prefix)
		{
			Write-Host ($prefix, $business_prefix, $obj_name) -Separator '_' -ForegroundColor DarkYellow;
		};
	}
	elseif ($item -eq 'table')
	{
		foreach ($prefix in $table_prefix.where{$_ -match $table_type})
		{
			Write-Host ($prefix, $business_prefix, $obj_name) -Separator '_' -ForegroundColor Blue;
		};
	}
	elseif ($item -eq 'extract')
	{
		foreach ($prefix in $extract_prefix)
		{
			Write-Host ($prefix, $business_prefix, $obj_name) -Separator '_' -ForegroundColor Green;
		};
	};
};
