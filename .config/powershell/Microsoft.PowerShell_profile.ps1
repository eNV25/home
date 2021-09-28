
# change annoyting colors
Set-PSReadLineOption -Colors @{
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


function Global:Prompt {
    $regex = [regex]::Escape($home) + "(/.*)*$"
    $dir = "$($pwd.Path -Replace $regex, '~$1')"
    Write-Host "PowerShell" -ForegroundColor green -NoNewLine
    Write-Host " " -NoNewLine
    Write-Host "$dir" -ForegroundColor blue -NoNewLine
    if (Get-Command Write-VcsStatus -errorAction SilentlyContinue) { Write-VcsStatus }
    Write-Host " " -NoNewLine
    return "» "
}

# vim: ft=powershell
