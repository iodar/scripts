# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# small utility that allows to get the disk usage of the current folder
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function Get-DiskUsageInBytes {
    param(
        # folder to be examined
        [Parameter(
            Mandatory = $false,
            Position = 1
        )]
        [string]
        $folder = "."
    )
    $measuredFolderObject = Get-ChildItem -Path $folder -Recurse | Measure-Object -Property Length -Sum
    [long] $sizeOfFolder = $measuredFolderObject.Sum -as [long]
    return $sizeOfFolder
}

function Get-UsageInCustomUnit {
    param (
        # folder to be examined
        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [string]
        $folder,

        # custom unit for displaying the size of the current folder
        [Parameter(
            Mandatory = $false,
            Position = 2
        )]
        [ValidateSet(
            "BYTES",
            "KILO_BYTES",
            "MEGA_BYTES",
            "GIGA_BYTES"
        )]
        [string]
        $unit
    )

    [long] $initialSize = $(get-DiskUsageInBytes -folder $folder)

    New-Variable -Option Constant -Name KILO_BYTES -Value 1024
    New-Variable -Option Constant -Name MEGA_BYTES -Value $($KILO_BYTES * 1024)
    New-Variable -Option Constant -Name GIGA_BYTES -Value $($MEGA_BYTES * 1024)

    $customSize = 0

    switch ($unit) {
        "BYTES" { $customSize = $initialSize; break }
        "KILO_BYTES" { $customSize = $initialSize / $KILO_BYTES; break }
        "MEGA_BYTES" { $customSize = $initialSize / $MEGA_BYTES; break }
        "GIGA_BYTES" { $customSize = $initialSize / $GIGA_BYTES; break }
        Default { $customSize = $initialSize; break }
    }

    return [PSCustomObject]@{
        size = [math]::Round($customSize)
        path = $folder
    }
}

function Get-BestDisplaySize {
    param(
        # initial size in bytes
        [long] $sizeInBytes
    )

    [bool] $done = $false
    [int] $power = 1

    while ($done -ne $true) {
        $sizeInCustomFormat = ($sizeInBytes / [math]::Pow(1024, $power))
        if ($sizeInCustomFormat -lt 1) {
            $done = $true
        } else {
            $power++
        }
    }
    return $power-1
}

enum Unit {
    Bytes;
    KBytes;
    MBytes;
    GBytes;
    TBytes;
    PBytes;
}

function Get-DisplayUnit {
    param(
        [int] $power
    )
    [Unit] $displayUnit = $power
    return $displayUnit
}

function Get-DiskUsage {
    param(
        # folder to get the disk usage of
        [Parameter(Position = 1, Mandatory = 0)]
        [string]
        $folder = "."
    )
    
    [long] $folderSizeInBytes = Get-DiskUsageInBytes -folder $folder
    $optimalPower = Get-BestDisplaySize -sizeInBytes $folderSizeInBytes
    [Unit] $optimalUnit = Get-DisplayUnit -power $optimalPower
    $folderSizeInCustomUnit = [System.Math]::Round(($folderSizeInBytes / [math]::Pow(1024, $optimalPower)), 2)

    return [PSCustomObject]@{
        folder = $folder
        size = $folderSizeInCustomUnit
        unit = $optimalUnit
    }
}