# source test subject
. .\checkPesterVersion.ps1


Describe "runTest" {
    Context "lower version" {
        Mock Get-InstalledPesterVersion {
            return New-Object -TypeName System.Version -ArgumentList 3, 4, 0, 1
        }
        
        It "when major version lower than 4 => prints message to std out" {
            $runPesterOutput = Test-IfPesterVersionIsSufficient 6>&1
            $runPesterOutput | Should -BeExactly "Your Pester version is `"3.4.0.1`". Major Version '4' is recommanded."
        }
    }
    

}