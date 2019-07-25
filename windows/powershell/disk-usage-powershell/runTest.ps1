# source helper script
. ..\checkPesterVersion\checkPesterVersion.ps1

if (Test-IfPesterVersionIsSufficient -eq $true) {
    Invoke-Pester
} 