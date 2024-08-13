Function Get-FriendlySize {
    Param($bytes)
    switch($bytes){
        {$_ -gt 1TB}{"{0:N2} TB" -f ($_ / 1TB);break}
        {$_ -gt 1GB}{"{0:N2} GB" -f ($_ / 1GB);break}
        {$_ -gt 1MB}{"{0:N2} MB" -f ($_ / 1MB);break}
        {$_ -gt 1KB}{"{0:N2} KB" -f ($_ / 1KB);break}
        default {"{0:N2} Bytes" -f $_}
    }
}


# Drives to check: set to $null or empty to check all local (non-network) drives
$drives = @("C","D","E","F","G");
#$drives = $null;
 
# The minimum disk size to check for raising the warning
$minSize = 50GB
 
# SMTP configuration: username, password & so on
$email_username = "administrator@partnercoloradocu.org";
$email_password = "P@rtn3r*6@@1";
$email_smtp_host = "mx2.partnercoloradocu.org";
$email_smtp_port = 25;
$email_smtp_SSL = 0;
$email_from_address = "ps-script@partnercoloradocu.org";
$email_to_addressArray = @("matthewh@partnercoloradocu.org", "jons@partnercoloradocu.org"); #, "to2@yourdomain.com"
 
 
if ($drives -eq $null -Or $drives -lt 1) {
    $localVolumes = Get-WMIObject win32_volume;
    $drives = @();
    foreach ($vol in $localVolumes) {
        if ($vol.DriveType -eq 3 -And $vol.DriveLetter -ne $null ) {
            $drives += $vol.DriveLetter[0];
        }
    }
}
foreach ($d in $drives) {
    Write-Host ("`r`n");
    Write-Host ("Checking drive " + $d + " ...");
    $disk = Get-PSDrive $d;
    if ($disk.Free -lt $minSize) {
        $freeSpace = Get-FriendlySize $disk.Free
        $usedSpace = Get-FriendlySize $disk.Used
        Write-Host ("Drive " + $d + " has less than " + $minSize `
            + " free (" + $freeSpace + "): sending e-mail...");
        
        $message = new-object Net.Mail.MailMessage;
        $message.From = $email_from_address;
        foreach ($to in $email_to_addressArray) {
            $message.To.Add($to);
        }
        $message.Subject =  ("[RunningLow] WARNING: " + $env:computername + " drive " + $d);
        $message.Subject += (" has less than " + $(Get-FriendlySize $minSize) + " free ");
        $message.Subject += ("(" + $disk.Free + ")");
        $message.Body =     "Hello there, `r`n`r`n";
        $message.Body +=    "this is an automatic e-mail message ";
        $message.Body +=    "sent by RunningLow Powershell script ";
        $message.Body +=    ("to inform you that " + $env:computername + " drive " + $d + " ");
        $message.Body +=    "is running low on free space. `r`n`r`n";
        $message.Body +=    "--------------------------------------------------------------";
        $message.Body +=    "`r`n";
        $message.Body +=    ("Machine HostName: " + $env:computername + " `r`n");
        $message.Body +=    "Machine IP Address(es): ";
        $ipAddresses = Get-NetIPAddress -AddressFamily IPv4;
        foreach ($ip in $ipAddresses) {
            if ($ip.IPAddress -like "127.0.0.1") {
                continue;
            }
            $message.Body += ($ip.IPAddress + " ");
        }
        $message.Body +=    "`r`n";
        $message.Body +=    ("Used space on drive " + $d + ": " + $usedSpace + ". `r`n");
        $message.Body +=    ("Free space on drive " + $d + ": " + $freeSpace + ". `r`n");
        $message.Body +=    "--------------------------------------------------------------";
        $message.Body +=    "`r`n`r`n";
        $message.Body +=    "This warning will fire when the free space is lower ";
        $message.Body +=    ("than " + $(Get-FriendlySize $minSize) + " `r`n`r`n");
        $message.Body +=    "Sincerely, `r`n`r`n";
        $message.Body +=    "-- `r`n";
        $message.Body +=    "RunningLow`r`n";
                #$message.Body +=        "https://www.ryadel.com/RunningLow";
 
        $smtp = new-object Net.Mail.SmtpClient($email_smtp_host, $email_smtp_port);
        $smtp.EnableSSL = $email_smtp_SSL;
        $smtp.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password);
        $smtp.send($message);
        $message.Dispose();
        write-host "... E-Mail sent!" ; 
    }
    else {
        Write-Host ("Drive " + $d + " has more than " + $(Get-FriendlySize $minSize) + " free: nothing to do.");
    }
}

