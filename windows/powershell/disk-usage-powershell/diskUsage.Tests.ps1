# testdata
$notEmptyFolderPath = ".\testdata\not-empty-folder"
$emptyFolderPath = ".\testdata\empty-folder"

# source script
. .\diskUsage.ps1

Describe "get-DiskUsageInBytes" {
    It "if folder not empty => calcs the correct amount of bytes in folder" {
        $sizeOfTestdataFolder = get-DiskUsageInBytes -folder $notEmptyFolderPath
        $sizeOfTestdataFolder | Should -BeExactly 68448
    }
    
    It "if folder empty => calcs the correct amount of bytes in folder" {
        $sizeOfTestdataFolder = get-DiskUsageInBytes -folder $emptyFolderPath
        $sizeOfTestdataFolder | Should -BeExactly 0
    }

    It "if not folder given => uses the current folder to calc size" {
        # FIXME: There has to be a better way        
        # save current location for later use -> otherwise the terminal will terminate in
        # another location than intinally started (very annoying)
        $initalLocation = $pwd.Path
        # change location to testdata folder
        Set-Location -Path $notEmptyFolderPath
        $sizeOfTestdataFolder = get-DiskUsageInBytes
        $sizeOfTestdataFolder | Should -BeExactly 68448
        # return to location
        Set-Location -Path $initalLocation
    }
}

Describe "get-UsageInCustomUnit" {
    It "no unit given => calculates size in bytes" {
        $sizeOfTestdataFolder = get-UsageInCustomUnit -folder $notEmptyFolderPath
        $sizeOfTestdataFolder | Should -BeExactly 68448
    }

    Context "get Usage by unit" {
        It "given -unit '<unit>', it should return exactly '<expectedValue>'" -TestCases @(
            @{folder = $notEmptyFolderPath; unit = "BYTES"; expectedValue = 68448}
            @{folder = $notEmptyFolderPath; unit = "KILO_BYTES"; expectedValue = 67}
            @{folder = $notEmptyFolderPath; unit = "MEGA_BYTES"; expectedValue = 0}
            @{folder = $notEmptyFolderPath; unit = "GIGA_BYTES"; expectedValue = 0}
        ) {
            param(
                [string] $folder,
                [string] $unit,
                [string] $expectedValue
            )
            $sizeOfTestdataFolder = get-UsageInCustomUnit -folder $folder -unit $unit
            $sizeOfTestdataFolder | Should -BeExactly $expectedValue
        }
    }
}