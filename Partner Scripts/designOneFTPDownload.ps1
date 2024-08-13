param (
    $remotePath = "/",
    $localPath = "I:\DesignOneCardImages\",
    $wildcard = "*.jpg"
    
)
 
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Ftp
        HostName = "www.picturemycard.com"
        PortNumber = 21
        UserName = "pccuftp.picturemycard.com|pccu"
        Password = "tour20r90@1"
        FtpSecure = [WinSCP.FtpSecure]::Explicit
        TlsHostCertificateFingerprint = "19:fa:f4:94:f6:f7:6c:78:ca:c9:1f:a4:df:98:eb:7d:52:7d:38:71"
    }

    $sessionOptions.AddRawSettings("FtpPingType", "0")

    $session = New-Object WinSCP.Session

    try
        {
            # Connect
            $session.Open($sessionOptions)
 
            # Get list of matching files in the directory
            $files = $session.EnumerateRemoteFiles($remotePath, $wildcard, [WinSCP.EnumerationOptions]::None)
 
            # Any file matched?
            if ($files.Count -gt 0)
            {
                # Download files
                $transferOptions = New-Object WinSCP.TransferOptions
                $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
 
                $transferResult = $session.GetFiles($remotePath + $wildcard, $localPath, $False, $transferOptions)
 
                # Throw on any error
                $transferResult.Check()
 
                # Print results
                foreach ($transfer in $transferResult.Transfers)
                {
                   Write-Host ("Download of {0} succeeded" -f $transfer.FileName)
                   # Download succeeded, remove file from source
                    $removalResult = $session.RemoveFiles($session.EscapeFileMask($transfer.FileName))
 
                    if ($removalResult.IsSuccess)
                    {
                        Write-Host ("Removing of file {0} succeeded" -f $transfer.FileName)
                    }
                    else
                    {
                        Write-Host ("Removing of file {0} failed" -f $transfer.FileName)
                    } 
                }
            }
            else
            {
                Write-Host ("No files matching {0} found" -f $wildcard)
            }
        }
        finally
        {
            # Disconnect, clean up
            $session.Dispose()
        } 
        exit 0
    }
catch [Exception]
{
    Write-Host ("Error: {0}" -f $_.Exception.Message)
    exit 1
}
 
