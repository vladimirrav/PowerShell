Clear-Host;

$env:Path.split(';') -match "java"

Test-Path -Path (($env:Path.split(';') -match "java").Replace(";", "") + "\java.exe")

(($env:Path.split(';') -match "java").Replace(";", "") + "\java.exe")