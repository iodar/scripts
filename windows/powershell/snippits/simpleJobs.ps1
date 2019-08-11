function getRuntime {
    param(
        [datetime] $startTime,
        [datetime] $endTime
    )

    $runTime = $endTime - $startTime
    return [PSCustomObject]@{
        minutes      = $runTime.Minutes
        seconds      = $runTime.Seconds
        milliseconds = $runTime.Milliseconds
    }
}

$jobCode = {
    for ($i = 0; $i -lt 10; $i++) {
        Write-Host "Hello World"
        # Start-Sleep -Milliseconds 250
    }
}

$startTime = Get-Date
$job1 = Start-Job -ScriptBlock $jobCode -Name "job1"
$job2 = Start-Job -ScriptBlock $jobCode -Name "job2"
$job3 = Start-Job -ScriptBlock $jobCode -Name "job3"
$allJobs = Wait-Job $job1, $job2, $job3

$resultJob1 = Receive-Job $job1
$resultJob2 = Receive-Job $job2
$resultJob3 = Receive-Job $job3

$resultJob1, $resultJob2, $resultJob3

Remove-Job $allJobs

$endTime = Get-Date
getRuntime -startTime $startTime -endTime $endTime