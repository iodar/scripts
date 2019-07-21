function get-installedPesterVersion {
    return Get-InstalledModule -Name Pester | Select-Object Version
}

function runPesterTests {
    $recommandedPersterMajorVersion = "4"
    $installedPesterVersion = get-installedPesterVersion
    $installedPersterMajorVersion =$installedPesterVersion.Version.Major
    
    if ($installedPersterMajorVersion -lt $recommandedPersterMajorVersion) {
        Write-Host -ForegroundColor DarkYellow -Object "Your Pester version is `"$($installedPesterVersion.toString())`". Major Version $recommandedPersterMajorVersion is recommanded."
    } else {
        # Clear-Host
        # Write-Host "Running tests ... `n" -ForegroundColor Cyan
        # Invoke-Pester
    }

}

runPesterTests