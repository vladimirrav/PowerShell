Clear-Host
Write-Host (([char]9644).ToString() * 30)

# Array 1
$vr_1 = @()
$vr_1 += 13000
$vr_1 += 28.9 * 23

# Array 2
$vr_2 = @()
$vr_2 += 13700
$vr_2 += 200
$vr_2 += 47 * 23
$vr_2 += 642
$vr_2 += [Math]::Round($vr_2[0]/12, 2) * 12/12

$soma_1, $soma_2 = 0, 0

# Sum all elements in each array
$vr_1 | ForEach-Object {$soma_1 += $_}
$vr_2 | ForEach-Object {$soma_2 += $_}

if ($soma_1 -gt $soma_2)
{
    $char, $color = [char]10004, 'green'
}
elseif ($soma_1 -lt $soma_2)
{
    $char, $color = [char]10006, 'red'
}
else
{
    $char, $color = [char]11044, 'yellow'
}

Write-Host "$char`t" -NoNewline -ForegroundColor $color
Write-Host "Array 1".PadRight(12,' ') -NoNewline

Write-Host ("{0:N}" -f $soma_1).PadLeft(10,' ') -ForegroundColor $color

if ($soma_2 -gt $soma_1)
{
    $char, $color = [char]10004, 'green'
}
elseif ($soma_2 -lt $soma_1)
{
    $char, $color = [char]10006, 'red'
}
else
{
    $char, $color = [char]11044, 'yellow'
}

write-host "$char`t" -NoNewline -ForegroundColor $color
Write-Host "Array 2".PadRight(12,' ') -NoNewline

Write-Host ("{0:N}" -f $soma_2).PadLeft(10,' ') -ForegroundColor $color

Write-Host (([char]8226).ToString() * 30)

if ($soma_2 -gt $soma_1)
{
    $color = 'green'
}
elseif ($soma_2 -lt $soma_1)
{
    $color = 'red'
}
else
{
    $color = 'blue'
}
$char = [char]10148

Write-Host "$char`t" -NoNewline -ForegroundColor $color
Write-Host "Difference".PadRight(12,' ') -NoNewline
Write-Host ("{0:N}" -f ($soma_2 - $soma_1)).PadLeft(10,' ') -ForegroundColor $color

Write-Host (([char]9644).ToString() * 30)