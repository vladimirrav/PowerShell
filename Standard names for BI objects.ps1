<#
	.SYNOPSIS
		Standard names for BI objects

	.DESCRIPTION
		Standard names for BI objects for table, job and Tableau extract according to business rules

	.PARAMETER table_prefix
		Table prefix: BT, DM or LK

	.PARAMETER job_prefix
		Prefix for the job: BQ

	.PARAMETER extract_prefix
		Prefix for the Table extract: HYPER

	.PARAMETER business_acronym
		Acronym for the business unit: MR

	.PARAMETER object_name
		Object name

	.NOTES
		Author: Vladimir Rubinstein Andrade Vargas
		Date: 2023-08-24

	.EXAMPLE
		$documents = '/Users/user_name/Library/CloudStorage/GoogleDrive-user_email@company.com/Meu Drive/Powershell';
		Set-Location -Path $documents;
		& "$documents/Standard names for BI objects.ps1" -table_prefix 'DM' -job_prefix 'BQ' -extract_prefix 'HYPER' -business_acronym 'MR' -object_name 'OBJECT_NAME';
	
		$documents = [Environment]::GetFolderPath("MyDocuments");
		Set-Location -Path ($documents + '/Documents/Powershell/');
		& "$documents/Standard names for BI objects.ps1" -table_prefix 'DM' -job_prefix 'BQ' -extract_prefix 'HYPER' -business_acronym 'MR' -object_name 'OBJECT_NAME';
#>

param (
	[string]$table_prefix = 'DM',
	[string]$job_prefix = 'BQ',
	[string]$extract_prefix = 'HYPER',
	[string]$business_acronym = 'MR',
	[string]$object_name = 'OBJECT_NAME'
);

<# For testing
	[string]$table_prefix = 'DM';
	[string]$job_prefix = 'BQ';
	[string]$extract_prefix = 'HYPER';
	[string]$business_acronym = 'MR';
	[string]$object_name = 'OBJECT_NAME';
#>

$object_types = @('job', 'table', 'extract');

$prefixes = @{
	job = $job_prefix
	table = $table_prefix
	extract = $extract_prefix
};

# Iterate over all the object types
foreach ($object_type in $object_types)
{
	# Get the prefix for the current object type
	$prefix = $prefixes[$object_type];
	$colors = [enum]::GetValues([System.ConsoleColor]);
	$color = Switch ($object_type)
	{
		'job' {Get-Random -InputObject($colors | Select-Object -First 5 -Skip 1)}
		'table' {Get-Random -InputObject($colors | Select-Object -First 5 -Skip 6)}
		'extract' {Get-Random -InputObject($colors | Select-Object -First 5 -Skip 11)}
		Default {'White'}
	};

	# Iterate over the object prefixes
	foreach ($object_prefix in $prefix)
	{
		# Format the output
		Write-Host (("{0}`t{1}_{2}_{3}" -f ((Get-Culture).TextInfo.ToTitleCase($object_type.ToLower())), $object_prefix, $business_acronym, $object_name)) -ForegroundColor $color;
	};
};