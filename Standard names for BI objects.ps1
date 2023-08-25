<#
	.SYNOPSIS
	Standard names for BI objects

	.DESCRIPTION
	Standard names for BI objects for table, job and Tableau extract according to business rules

	.PARAMETER obj_name
	Object name

	.PARAMETER table_type
		Table type: BT, DM or LK

	.NOTES
		Author: Vladimir Rubinstein Andrade Vargas
		Date: 2023-08-24

	.EXAMPLE
		$documents = '/Users/user_name/Library/CloudStorage/GoogleDrive-user_email@company.com/Meu Drive/Powershell';
		Set-Location -Path $documents;
		& "$documents/Standard names for BI objects.ps1" -obj_name 'OBJECT_NAME' -table_type 'DM' -business_acronym 'MR';
	
		$documents = [Environment]::GetFolderPath("MyDocuments");
		Set-Location -Path ($documents + '/Documents/Powershell/');
		& "$documents/Standard names for BI objects.ps1" -obj_name 'OBJECT_NAME' -table_type 'DM' -business_acronym 'MR';
#>

param (
	[string]$obj_name = 'OBJECT_NAME',
	[string]$table_type = 'DM',
	[string]$business_acronym = 'MR'
);

$object_type = @('job', 'table', 'extract');
$table_prefix = @('DM', 'BT', 'LK') | Sort-Object;
# $table_type = 'DM';
$job_prefix = @('BQ');
# $business_acronym = 'MR';
$extract_prefix = @('HYPER');
# $obj_name = 'OBJECT_NAME';

foreach ($item in $object_type)
{
	Write-Host ((Get-Culture).TextInfo.ToTitleCase($item.ToLower()) + "`t") -NoNewline;
	if ($item.ToLower() -eq 'job'.ToLower())
	{
		foreach ($prefix in $job_prefix)
		{
			Write-Host ($prefix, $business_acronym, $obj_name) -Separator '_' -ForegroundColor DarkYellow;
		};
	}
	elseif ($item.ToLower() -eq 'table'.ToLower())
	{
		foreach ($prefix in $table_prefix.where{$PSItem -match $table_type})
		{
			Write-Host ($prefix, $business_acronym, $obj_name) -Separator '_' -ForegroundColor Blue;
		};
	}
	elseif ($item.ToLower() -eq 'extract'.ToLower())
	{
		foreach ($prefix in $extract_prefix)
		{
			Write-Host ($prefix, $business_acronym, $obj_name) -Separator '_' -ForegroundColor Green;
		};
	};
};
