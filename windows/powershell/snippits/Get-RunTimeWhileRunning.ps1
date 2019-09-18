# displays the live runtime of a script in minutes and seconds
$startTime = Get-Date
while ($true -eq $true) {
    $timeDiff = $(Get-Date) - $startTime
    write-host -NoNewline "`rruntime: $($timeDiff.Minutes)m $($timeDiff.Seconds)s"
    Start-Sleep -Milliseconds 250
}