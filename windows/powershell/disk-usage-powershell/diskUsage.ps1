# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# small utility that allows to get the disk usage of the current folder
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function get-DiskUsageInBytes {
    param(
        # folder to be examined
        [Parameter(
            Mandatory = $false,
            Position = 1
        )]
        [string]
        $folder = "."
    )
    $sizeOfFolder = 0
    Get-ChildItem -Path $folder -Recurse | ForEach-Object {
        $sizeOfFolder += $_.Length
    }
    return $sizeOfFolder
}

function get-UsageInCustomUnit {
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
            Mandatory = $true,
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

    $initialSize = $(get-DiskUsageInBytes -folder $folder)

    New-Variable -Option Constant -Name KILO_BYTES -Value 1024
    New-Variable -Option Constant -Name MEGA_BYTES -Value $($KILO_BYTES*1024)
    New-Variable -Option Constant -Name GIGA_BYTES -Value $($MEGA_BYTES*1024)

    $customSize = 0

    switch ($unit) {
        "BYTES"         { $customSize = $initialSize; break }
        "KILO_BYTES"    { $customSize = $initialSize/$KILO_BYTES; break }
        "MEGA_BYTES"    { $customSize = $initialSize/$MEGA_BYTES; break }
        "GIGA_BYTES"    { $customSize = $initialSize/$GIGA_BYTES; break }
        Default         { $customSize = $initialSize; break }
    }
    return [math]::Round($customSize)
}

Write-Output "$(get-UsageInCustomUnit "E:\Programme" GIGA_BYTES)G`t."