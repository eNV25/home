
# »
function Global:Prompt {
    $regex = [regex]::Escape($home) + "(/.*)*$"
    $pwd = "$($pwd.Path -replace $regex, '~$1')"
    Write-Host "PowerShell" -foregroundColor green -noNewLine
    Write-Host ":" -noNewLine
    Write-Host "$pwd/" -foregroundColor blue -noNewLine
    try { Write-VcsStatus } catch { }
    return "» "
}


# vim: ft=powershell
