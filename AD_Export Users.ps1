Get-ADUser -Filter * -Properties * | Select-Object name | export-csv -path C:\export\allusers.csv
