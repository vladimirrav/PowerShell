Clear-Host;
$dist = 4 * 2;
$sep = " | ";
$kml_G = 13.6;
$price_LG = 6.6;
$kml_E = 11.8;
$price_LE = 5.2;

# Calc
$km100_E = [math]::Round((100 / $kml_E), 1);
$km100_G = [math]::Round((100 / $kml_G), 1);
$qt_litters_G = [math]::Round(($dist / 100 * $km100_G), 1);
$qt_litters_E = [math]::Round(($dist / 100 * $km100_E), 1);
$value_Km_G = [math]::Round(($price_LG / $kml_G), 2);
$value_Km_E = [math]::Round(($price_LE / $kml_E), 2);
$value_100Km_G = [math]::Round((100 / $kml_G * $price_LG), 2);
$value_100Km_E = [math]::Round((100 / $kml_E * $price_LE), 2);
$value_G = [math]::Round(($price_LG * $dist / 100 * $km100_G), 2);
$value_E = [math]::Round(($price_LE * $dist / 100 * $km100_E), 2);

# Output
Write-Host "Distance"$dist.ToString('#,##0')"Km";
Write-Host "Km/L ratio E/G"($kml_E / $kml_G * 100).ToString('0.0')"%";
Write-Host '$$$ ratio E/G'($price_LE / $price_LG * 100).ToString('0.0')"%";

Write-Host "G " -NoNewline;
Write-Host "Km/L: $kml_G"-NoNewline;
Write-Host $sep -NoNewline;
Write-Host "R$/Km"$value_Km_G.ToString('0.00') -NoNewline;
Write-Host $sep -NoNewline;
Write-Host $qt_litters_G.ToString('#,##0.0')"L" -NoNewline;
Write-Host $sep -NoNewline;
Write-Host "R$"$value_G.ToString('#,##0.00') -NoNewline;
Write-Host $sep -NoNewline;
Write-Host "L/100 Km: $km100_G" -NoNewline;
Write-Host $sep -NoNewline;
Write-Host "R$/100 Km: $value_100Km_G";

Write-Host "E " -NoNewline;
Write-Host "Km/L: $kml_E"-NoNewline;
Write-Host $sep -NoNewline;
Write-Host "R$/Km"$value_Km_E.ToString('0.00') -NoNewline;
Write-Host $sep -NoNewline;
Write-Host $qt_litters_E.ToString('#,##0.0')"L" -NoNewline;
Write-Host $sep -NoNewline;
Write-Host "R$"$value_E.ToString('#,##0.00') -NoNewline;
Write-Host $sep -NoNewline;
Write-Host "L/100 Km: $km100_E" -NoNewline;
Write-Host $sep -NoNewline;
Write-Host "R$/100 Km: $value_100Km_E";
