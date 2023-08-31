<#
    .SYNOPSIS
        Available colors for console
    .DESCRIPTION
        The list of available colors for writing to the console.
    .NOTES
        Author: Vladimir
#>

$colors = [Enum]::GetValues([System.ConsoleColor]);

foreach ($color in $colors)
{
    $n = [int](((Get-Random -Minimum 90 -Maximum (100 + 1))/100) * 100);
    Write-Host ([char]12321, (([char]9608).toString() * $n).PadRight(100, ' '), [char]12321), $n.toString().PadLeft(3, ' '), $color -ForegroundColor $color;
};