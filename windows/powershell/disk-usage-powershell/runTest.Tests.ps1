. .\runTest.ps1

Mock get-installedPesterVersion {
    return New-Object -TypeName System.Version -ArgumentList 3,4,0,1
}

Describe "runTest" {
    It "when major version lower than 4 => prints message to std out" {
        $runPesterOutput = runPesterTests 6>&1
        $runPesterOutput | Should -BeExactly "Your Pester version is `"3.4.0.1`". Major Version 4 is recommanded."
    }
}