function Get-InstalledPesterVersion {
    return Get-InstalledModule -Name Pester | Select-Object Version
}

function Test-IfPesterVersionIsSufficient {
    $recommendedPersterMajorVersion = '4'
    $installedPesterVersion = Get-InstalledPesterVersion
    $installedPersterMajorVersion = $installedPesterVersion.Version.Major
    
    if ($installedPersterMajorVersion -lt $recommendedPersterMajorVersion) {
        Write-Host "Your Pester version is '$($installedPesterVersion.Version.toString())'. Major Version '$recommendedPersterMajorVersion' is recommended." -ForegroundColor DarkYellow
        return $false
    } else {
        Write-Host "Your Pester version is '$($installedPesterVersion.Version.toString())' which is above the recommended major verson '$recommendedPersterMajorVersion'." -ForegroundColor Green
        return $true
    }
}