<#
    $path = "C:\Users\vladi\OneDrive\Documentos\COVID-19\Dataset\GEO\countries-master\data\flags\";
    Set-Location -Path "C:\Users\vladi\OneDrive\Documentos\COVID-19\Script"
    .\Base64.ps1 -path $path -sql_instance_name "." -db_name "COVID-19"

    
    SSIS
    RequiredFullFileName
        C:\Program Files\PowerShell\7\pwsh.exe
    WorkingDirectory
        C:\Users\vladi\OneDrive\Documentos\COVID-19\Script
    Arguments
        .\Base64.ps1 -path "C:\Users\vladi\OneDrive\Documentos\COVID-19\Dataset\GEO\countries-master\data\flags\" -sql_instance_name "." -db_name "COVID-19"
        -ExecutionPolicy Unrestricted -File "C:\Users\vladi\OneDrive\Documentos\COVID-19\Script\Base64.ps1" -path "C:\Users\vladi\OneDrive\Documentos\COVID-19\Dataset\GEO\countries-master\data\flags\" -sql_instance_name "." -db_name "COVID-19"
#>

Param(
    [String]$path = "C:\Users\vladi\OneDrive\Documentos\COVID-19\Dataset\GEO\countries-master\data\flags\",
    [String]$sql_instance_name = '.',
    [String]$db_name = 'COVID-19'
)

Clear-Host

$Host.UI.RawUI.WindowTitle = 'Import image as Base64';

# [convert]::ToBase64String((get-content $path -encoding byte))

# Set-ExecutionPolicy Unrestricted

# $sql_instance_name = '.'
# $db_name = 'COVID-19'
# $path = "C:\Users\vladi\OneDrive\Documentos\COVID-19\Dataset\GEO\countries-master\data\flags\"

if ($path.Substring($path.Length - 1, 1) -ne "\")
{
    $path += "\"
}

$sql_statement = "truncate table ods.country_flag;"

Invoke-Sqlcmd -Database $db_name -Query $sql_statement -ServerInstance $sql_instance_name

$sizes = @('PNG-32', 'PNG-128')

foreach ($size in $sizes)
{
    $items = Get-ChildItem -Path ($path + "$size\") | Select-Object FullName
    Write-Host $size
    foreach ($item in $items)
    {
        $country_code = (Split-Path -Path $item.FullName -Leaf).Substring(0, 2)
        #Write-Host (Split-Path -Path $item.FullName -Leaf).Substring(0, 2)
        $file_name = (Split-Path -Path $item.FullName -Leaf).Split('.')[0]
        $ext = (Split-Path -Path $item.FullName -Leaf).Split('.')[1]
        $prefix = "data:image/$ext;base64, "

        # $image_b64 = [convert]::ToBase64String((Get-Content -Path $item.FullName -Encoding Byte)) # Antigo
        $image_b64 = [convert]::ToBase64String([System.IO.File]::ReadAllBytes($item.FullName))
        
        if ($size -match '32')
        {
            $sql_statement = "insert into ods.country_flag (
	            country_code_2,
	            prefix,
	            image_32px,
	            load_date
            ) values (
	            '$country_code',
	            '$prefix',
	            '$image_b64',
	            current_timestamp
            );";
        }
        else
        {
            $sql_statement = "update ods.country_flag
	        set image_128px = '$image_b64'
            where country_code_2 = '$country_code';";
        }
        Write-Host $country_code
        Invoke-Sqlcmd -Database $db_name -Query $sql_statement -ServerInstance $sql_instance_name
    }
}

# $sql_statement = "update f
# set country_code_3 = coalesce(c.[ISO3166-1-Alpha-3], n.[ISO-3166 alpha3]),
# 	country_code = coalesce(c.[ISO3166-1-numeric], n.[ISO-3166 numeric])
# from ods.country_flag as f
# left join ods.Countries as c on f.country_code_2 = c.[ISO3166-1-Alpha-2]
# left join ods.Geonames as n on f.country_code_2 = n.[ISO-3166 alpha2];"

# Invoke-Sqlcmd -Database $db_name -Query $sql_statement -ServerInstance $sql_instance_name

# $Base64 = Get-Content -Raw -Path .\capture.txt
# $Image = [Drawing.Bitmap]::FromStream([IO.MemoryStream][Convert]::FromBase64String($Base64))
# $Image.Save("<path>\Image2.jpg")
