
# change annoyting colors
Set-PSReadLineOption -colors @{
    # None      = 'white';
    # Comment   = 'white';
    Keyword   = 'white';
    # String    = 'white';
    Operator  = 'white';
    # Variable  ='white';
    Command   = 'white';
    Parameter = 'white';
    # Type      = 'white';
    # Number    = 'white';
    # Member    = 'white';
}

# »
function Global:Prompt {
    $regex = [regex]::Escape($home) + "(/.*)*$"
    $pwd = "$($pwd.Path -replace $regex, '~$1')"
    Write-Host "PowerShell" -foregroundColor green -noNewLine
    Write-Host " " -noNewLine
    Write-Host "$pwd" -foregroundColor blue -noNewLine
    try { Write-VcsStatus } catch { }
    return " » "
}

# vim: ft=powershell
