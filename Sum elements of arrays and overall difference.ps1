Clear-Host
Write-Host ('-' * 27)

# Array 1
$vr_1 = @()
$vr_1 += 7500
$vr_1 += 300

# Array 2
$vr_2 = @()
$vr_2 += 8000
$vr_2 += 1000

$soma_1, $soma_2 = 0, 0

# Sum all elements in each array
$vr_1 | ForEach-Object {$soma_1 += $_}
$vr_2 | ForEach-Object {$soma_2 += $_}

if ($soma_1 -gt $soma_2)
{
    $char, $color = [char]10004, 'green'
}
else
{
    $char, $color = [char]10006, 'red'
}

Write-Host "$char`t" -NoNewline -ForegroundColor $color
Write-Host "Array 1".PadRight(12,' ') -NoNewline

Write-Host ("{0:N}" -f $soma_1).PadLeft(10,' ') -ForegroundColor $color

if ($soma_2 -gt $soma_1)
{
    $char, $color = [char]10004, 'green'
}
else
{
    $char, $color = [char]10006, 'red'
}

write-host "$char`t" -NoNewline -ForegroundColor $color
Write-Host "Array 2".PadRight(12,' ') -NoNewline

Write-Host ("{0:N}" -f $soma_2).PadLeft(10,' ') -ForegroundColor $color

Write-Host (([char]11037).ToString() * 30)

if ($soma_2 -gt $soma_1)
{
    $color = 'green'
}
else
{
    $color = 'red'
}
$char = [char]10148

Write-Host "$char`t" -NoNewline -ForegroundColor $color
Write-Host "Difference".PadRight(12,' ') -NoNewline
Write-Host ("{0:N}" -f ($soma_2 - $soma_1)).PadLeft(10,' ') -ForegroundColor $color

Write-Host ('-' * 27)