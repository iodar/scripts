<#
## Gets all aviable smb mappings and creates an new connection
## if the drive is currently not connected
#>
Get-SmbMapping | Where-Object Status -NE "OK" | ForEach-Object {
    $smbProps = @{
        localPath = $_.LocalPath
        remotePath = $_.RemotePath
    }
    New-SmbMapping -LocalPath $smbProps.localPath -RemotePath $smbProps.remotePath
}