function getArgs {
    param(
        $cmdLineArgs
    )
    for ($i = 0; $i -lt $cmdLineArgs.Count; $i++) {
        if ($cmdLineArgs[$i] -eq "-count") {
            $count = $cmdLineArgs[$i+1]
        } elseif ($cmdLineArgs[$i] -eq "-threads") {
            $threads = $cmdLineArgs[$i+1]
        } elseif ($cmdLineArgs[$i] -eq "-url") {
            $url = $cmdLineArgs[$i+1]
        }
    }
    return [PSCustomObject]@{
        count = $count
        threads = $threads
        url = $url
    }
}

function callRestEndpoint {
    param(
        [int] $times,
        [string] $url
    )

    for ($i = 0; $i -lt $times; $i++) {
        $response = Invoke-WebRequest -Uri $url
        $response.StatusCode
    }
    
}

function launchParallelWebRequests {
    $scriptArgs = getArgs -cmdLineArgs $args
    
    for ($threads = 0; $threads -lt $scriptArgs.threads; $threads++) {
        Start-Job -Name "worker$thread" -ScriptBlock {
            callRestEndpoint -url $scriptArgs.url -times $($scriptArgs.count/$scriptArgs.threads)
        } -ArgumentList ($scriptArgs)
    }
}

launchParallelWebRequests $args
# $scriptArgs = getArgs -cmdLineArgs $args
# callRestEndpoint -times $scriptArgs.count -url $scriptArgs.url