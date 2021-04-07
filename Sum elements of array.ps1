# Array of values
$vr = @()
$vr += 6261.69
$vr += -22.5
$vr += -174.1
$vr += -446.5
$vr += -112.31
$vr += -254.88

# Sum all elements
$s = 0
$vr | ForEach-Object {$s += $_}
Write-Host "Total:", ('{0:N}' -f $s)