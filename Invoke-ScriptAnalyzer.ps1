# Install-Module -Name PSScriptAnalyzer

Invoke-ScriptAnalyzer -Path (([Environment]::GetFolderPath("MyDocuments"))+"\Powershell") -Settings PSGallery -Recurse