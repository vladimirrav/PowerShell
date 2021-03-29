# Install-Module -Name SqlServer
Import-Module -Name SqlServer
Import-Module -Name sqlps

$serverInstance = "<server>"
$database = "<database>"
$schema = "<schema>"
$table = "<table>"

$options = New-Object -TypeName Microsoft.SqlServer.Management.Smo.ScriptingOptions
$options.DriAll = $true
$options.SchemaQualify = $true

$connection = New-Object -TypeName Microsoft.SqlServer.Management.Common.ServerConnection -ArgumentList $serverInstance
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $connection

$db_items = $server.Databases.Item($database).Tables.Item($table, $schema).Script($options) | ForEach-Object -Process { $_ + ";`n" }

foreach ($item in $db_items)
{
    Write-Host $item
};

#----------------------------------------------------------------------------------------------


Import-Module sqlps

$serverInstance = "<server>"
$user = "<user>"
$password = "<pasword>"
$database = "<database>"
$schema = "<schema>"
$table = "<table>"

$options = New-Object -TypeName Microsoft.SqlServer.Management.Smo.ScriptingOptions
$options.DriAll = $true
$options.SchemaQualify = $true

$connection = New-Object -TypeName Microsoft.SqlServer.Management.Common.ServerConnection -ArgumentList $serverInstance
$connection.LoginSecure = $false
$connection.Login = $user
$connection.Password = $password
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $connection

$server.Databases.Item($database).Tables.Item($table, $schema).Script($options) | ForEach-Object -Process { $_ + ";`n" }

