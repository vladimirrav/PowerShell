# Logoff user

quser | Select-String "f545740" | ForEach-Object {logoff ($_.tostring() -split ' +')[2]}