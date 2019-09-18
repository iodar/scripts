param(
    # host prefix
    [Parameter(Mandatory = 1, Position = 0)]
    [string]
    $hostPrefix
)
function Get-TimeDifference {
    param(
        $start,
        $end
    )
    $difference = $end - $startTime
    $runtime = [PSCustomObject]@{
        minutes = $difference.Minutes
        seconds = $difference.Seconds
        milliseconds = $difference.Milliseconds
    }
    return $runtime
}

function Get-FullHostAddress {
    param(
        [string] $hostPrefix,
        [int] $hostBit
    )

    if ($hostPrefix.EndsWith(".")) {
        return $hostPrefix + [string] $hostBit
    } else {
        return $hostPrefix + '.' + [string] $hostBit
    }
}

$hostsLastBits = 0..255

$repliesList = [System.Collections.ArrayList]@()

$startTime = Get-Date

foreach ($hostBit in $hostsLastBits) {
    $hostAddress = Get-FullHostAddress -hostPrefix $hostPrefix -hostBit $hostBit
    $replies = $(Test-Connection -ComputerName $hostAddress -TimeoutSeconds 2 -Count 1 -InformationAction Ignore)
    $reply = [PSCustomObject]@{
        address = $replies.Replies.Address.IPAddressToString
        message = $replies.Replies.status
    }

    $repliesList.Add($reply) > $null
}

$endTime = Get-Date

$repliesList | Where-Object message -Like "Success"

$runtime = Get-TimeDifference -start $startTime -end $endTime
"`nruntime: $($runtime.minutes)m $($runtime.seconds)s $($runtime.milliseconds)ms"