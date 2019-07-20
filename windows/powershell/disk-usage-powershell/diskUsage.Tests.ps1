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

# TODO: add tests for get-UsageInCustomUnit