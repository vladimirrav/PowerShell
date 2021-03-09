Write-Host "Github"

$documents = [Environment]::GetFolderPath("MyDocuments")

Set-Location -Path $documents
git init

git clone https://vladimirrav@github.com/vladimirrav/PowerShell.git
git clone https://vladimirrav@github.com/vladimirrav/T-SQL.git

Set-Location -Path $documents\PowerShell
Get-Location
git pull

Set-Location -Path $documents\T-SQL
Get-Location
git pull