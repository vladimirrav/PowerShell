# Clear-Host;
$mm = (0.5, 0.75, 1, 1.5, 2.5, 4, 6, 10, 16, 25, 35, 50, 70, 95, 120, 150, 185, 240);

$R = $null;  # Resistência elétrica do condutor em Ohm
$ρ = 0.0172; # Resistividade específica do material (0,0172 para o cobre).
$l = 15;     # Comprimento do condutor em metros.
$I = 35;     # Corrente elétrica em ampère.
$cosθ = 0.8; # Fator de potência.
# $S = 2.5;    # Seção do condutor em mm²
$Sc = [Math]::Round(($I * $l * 2) / (58 * $E * 0.03), 1);
$S = ($mm | Where-Object {
	$PSItem -ge $Sc -and $PSItem -ge 2.5
} | Select-Object -First 1);

$R = ($ρ * $l) / $S;

$ΔE = [Math]::Round(2 * $R * $I * $cosθ, 2);
$E = 220; # Tensão em volt.
$ΔE_pct = [math]::Round(100 * ($ΔE/$E), 2);

Write-Host "ρ = $ρ Ω"; # Resistividade específica do material
Write-Host "l = $l m";     # Comprimento do condutor em metros
Write-Host "S = $S mm²";    # Seção do condutor em mm²
Write-Host "E = $E V";		# Tensão em Volts
Write-Host "I = $I A";     # Corrente elétrica em ampère
Write-Host "cosθ = $cosθ"; # Fator de potência

Write-Host "* Cálculo da resistividade do condutor";
Write-Host ("`tResistividade específica do material: $ρ Ω");
Write-Host ("`tComprimento do condutor: $l m");
Write-Host ("`tSeção do condutor:", $Sc, "-->", $S, "mm²");
Write-Host ("`tResistividade do condutor: $R Ω");
Write-Host ("* Cálculo da queda de tensão");
Write-Host ("`tQueda de tensão: $ΔE V");
Write-Host ("`tPercentual de queda de tensão: $ΔE_pct %");