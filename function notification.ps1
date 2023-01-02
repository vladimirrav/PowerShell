<#
	.SYNOPSIS
		Balloon notification for password expiration.

	.DESCRIPTION
		Balloon notification for password expiration days before expiration.

	.PARAMETER date
		Date in witch the password has been changed.

	.PARAMETER days
		Number of days of the password expiration.

	.PARAMETER days_notification
		Number of days to start showing the balloon notification before the expiration date.

	.OUTPUTS
		A balloon notification in the notification section of the operating system

	.NOTES
		Author: Vladimir Rubinstein Andrade Vargas
		Date: 2022-12-29

	.EXAMPLE
		$directory = [Environment]::GetFolderPath("MyDocuments");
		$ps_directory = ([Environment]::GetFolderPath("MyDocuments") + '\PowerShell');
		$module = ($ps_directory + '\function notification.ps1').Replace('\\', '\');
		Import-Module $module;
		$file = $directory + '\vlrubins.txt'; # a file that stores the date the password was last changed in the first row in the format [string dd/mm/yyyy]
		$date = (Get-Content -Path $file -First 1).Split(' ')[1]
		fn_password_notification -date $date -days 30 -days_notification 5;

	.EXAMPLE
		$directory = [Environment]::GetFolderPath("MyDocuments");
		$ps_directory = ([Environment]::GetFolderPath("MyDocuments") + '\PowerShell');
		$module = ($ps_directory + '\function notification.ps1').Replace('\\', '\');
		Import-Module $module;
		fn_password_notification -date '2022-12-29' -days 30 -days_notification 5;
#>

function fn_password_notification (
		[String]$date,
		[Int16]$days,
		[Int16]$days_notification
	)
{
	$date = $date.Replace('-', '/');
	try {
		$dt = [datetime]::parseexact($date, 'dd/MM/yyyy', $null);
	}
	catch {
		$dt = [datetime]::parseexact($date, 'yyyy/MM/dd', $null);
	};
	$notification_date = $dt.AddDays($days - $days_notification);
	$expiration_date = $dt.AddDays($days);
	$ts = New-TimeSpan -Start (Get-Date) -End $expiration_date;

	Write-Host("Date:", $dt.ToString('dd/MM/yyyy'));
	Write-Host("Today date:", (Get-Date).ToString('dd/MM/yyyy'));
	Write-Host("Notification date:", $notification_date.ToString('dd/MM/yyyy'));
	Write-Host("Expiration date:", $expiration_date.ToString('dd/MM/yyyy'));
	if ($ts.Days -ge 0) {
		$msg = 'Password expiration in ' + $ts.Days + ' days: ' + [datetime]::parseexact($expiration_date.ToString('yyyy-MM-dd'), 'yyyy-MM-dd', $null).ToString('dd/MM/yyyy');
	}
	else {
		$msg = 'Password expired ' + [Math]::Abs($ts.Days) + ' days ago: ' + [datetime]::parseexact($expiration_date.ToString('yyyy-MM-dd'), 'yyyy-MM-dd', $null).ToString('dd/MM/yyyy');
	};
	Write-Host($msg);

	if((Get-Date) -ge $notification_date)
	{
		[reflection.assembly]::loadwithpartialname('System.Windows.Forms');
		[reflection.assembly]::loadwithpartialname('System.Drawing');
		$notify = new-object system.windows.forms.notifyicon;
		$notify.icon = [System.Drawing.SystemIcons]::Information;
		$notify.visible = $true;
		$notify.showballoontip(10,'Warning', $msg, [system.windows.forms.tooltipicon]::None);
	};
};