# import diskUsage module
using module .\diskUsage.psd1

# testdata
$notEmptyFolderPath = ".\testdata\not-empty-folder"
$emptyFolderPath = ".\testdata\empty-folder"

function Get-DiskUsageObject {
    param(
        [string] $path,
        [long] $size
    )

    return [PSCustomObject]@{
        size = $size
        path = $path
    }
}

Describe "diskUsage script" {
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
            # $expectedResult = Get-DiskUsageObject -path $notEmptyFolderPath -size 68448
            $expectedResult = Get-DiskUsageObject -path $notEmptyFolderPath -size 68448
            $sizeOfTestdataFolder = get-UsageInCustomUnit -folder $notEmptyFolderPath
            $sizeOfTestdataFolder | Should -BeLikeExactly $expectedResult
        }
    
        Context "get Usage by unit" {
            It "given -unit '<unit>', it should return exactly '<expectedValue>'" -TestCases @(
                @{folder = $notEmptyFolderPath; unit = "BYTES"; expectedValue = Get-DiskUsageObject -path $notEmptyFolderPath -size 68448 }
                @{folder = $notEmptyFolderPath; unit = "KILO_BYTES"; expectedValue = Get-DiskUsageObject -path $notEmptyFolderPath -size 67 }
                @{folder = $notEmptyFolderPath; unit = "MEGA_BYTES"; expectedValue = Get-DiskUsageObject -path $notEmptyFolderPath -size 0 }
                @{folder = $notEmptyFolderPath; unit = "GIGA_BYTES"; expectedValue = Get-DiskUsageObject -path $notEmptyFolderPath -size 0 }
            ) {
                param(
                    [string] $folder,
                    [string] $unit,
                    [string] $expectedValue
                )
                $sizeOfTestdataFolder = get-UsageInCustomUnit -folder $folder -unit $unit
                $sizeOfTestdataFolder | Should -BeLikeExactly $expectedValue
            }
        }
    }
}

Describe "Get-BestDisplaySize" {
    # test contants
    $oneKByte = 1 * 1024
    $oneMByte = $oneKByte * 1024
    $oneGByte = $oneMByte * 1024
    $oneTByte = $oneGByte * 1024
    $onePByte = $oneTByte * 1024
    
    It "given <bytes> <unit> => return should be <expectedReturn>" -TestCases @(
        @{bytes = $oneKByte-1; unit = "bytes"; expectedReturn = 0}
        @{bytes = $oneKByte; unit = "bytes"; expectedReturn = 1}
        @{bytes = $oneKByte+1; unit = "bytes"; expectedReturn = 1}
        @{bytes = $oneMByte-1; unit = "bytes"; expectedReturn = 1}
        @{bytes = $oneMByte; unit = "bytes"; expectedReturn = 2}
        @{bytes = $oneMByte+1; unit = "bytes"; expectedReturn = 2}
        @{bytes = $oneGByte-1; unit = "bytes"; expectedReturn = 2}
        @{bytes = $oneGByte; unit = "bytes"; expectedReturn = 3}
        @{bytes = $oneGByte+1; unit = "bytes"; expectedReturn = 3}
        @{bytes = $oneTByte-1; unit = "bytes"; expectedReturn = 3}
        @{bytes = $oneTByte; unit = "bytes"; expectedReturn = 4}
        @{bytes = $oneTByte+1; unit = "bytes"; expectedReturn = 4}
        @{bytes = $onePByte-1; unit = "bytes"; expectedReturn = 4}
        @{bytes = $onePByte; unit = "bytes"; expectedReturn = 5}
        @{bytes = $onePByte+1; unit = "bytes"; expectedReturn = 5}
    ) {
        param(
            [long] $bytes,
            [string] $unit,
            [int] $expectedReturn
        )
        $powerOf1024 = Get-BestDisplaySize -sizeInBytes $bytes
        $powerOf1024 | Should -BeExactly $expectedReturn
    }
}

Describe "Get-DisplayUnit" {
    It "given power <power> => return should be <expectedDisplayUnit>" -TestCases @(
        @{power = 0; expectedDisplayUnit = [Unit]::Bytes}
        @{power = 1; expectedDisplayUnit = [Unit]::KBytes}
        @{power = 2; expectedDisplayUnit = [Unit]::MBytes}
        @{power = 3; expectedDisplayUnit = [Unit]::GBytes}
        @{power = 4; expectedDisplayUnit = [Unit]::TBytes}
        @{power = 5; expectedDisplayUnit = [Unit]::PBytes}
    ) {
        param(
            [int] $power,
            [Unit] $expectedDisplayUnit
        )
        [Unit] $displayUnit = Get-DisplayUnit -power $power
        $displayUnit | Should -BeExactly $expectedDisplayUnit 
    }
}

Describe "Get-DiskUsage" {
    
    # function Get-UsageObject (OptionalParameters) {
        
    # }

    Mock Get-DiskUsageInBytes {
        return [long] 12 * [math]::Pow(1024, 2)
    }

    It "should get right amount" {
        $expectedResult = [PSCustomObject]@{
            folder = "."
            size = 84.59
            unit = [Unit]::KBytes
        }
        $result = Get-DiskUsage
        $result | Should -BeLike $expectedResult
    }
}
