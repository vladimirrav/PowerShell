Write-Host "Github"

$documents = [Environment]::GetFolderPath("MyDocuments")

Set-Location -Path $documents


git init

# Config ------------------------------------------------
    git config --global user.email "vladimirrav@github.com"
    git config --global user.name "vladimirrav"
# -------------------------------------------------------

git clone https://vladimirrav@github.com/vladimirrav/PowerShell.git
git clone https://vladimirrav@github.com/vladimirrav/T-SQL.git

Set-Location -Path $documents\PowerShell
Get-Location

git pull
git status
git add .
git commit -m "Github repositores"
git push

Set-Location -Path $documents\T-SQL
Get-Location
git pull
