<#
    .SYNOPSIS
    Character list

    .DESCRIPTION
    Display characters in a range.

    .OUTPUTS
    Unicode character and its code.
#>
Clear-Host;

8000..11500 |
ForEach-Object {
    Write-Host $_ ([char]$_);
};