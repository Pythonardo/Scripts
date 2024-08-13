function Show-Menu {
    param (
        [string]$Title = 'PARTNER In-Crime! BETA'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "`n 1. Network Rejack`n    - Simulates unplugging the computer's Ethernet cable, usually resolving 'Action Needed' errors."
    Write-Host "`n 2. Fix My IP`n    - Looks for mismatched IP address records, usually resolving Symitar 'Host not Authorized' errors."
    Write-Host "`n 3. Fix My System`n   - The computer will run through a file system integrity check, verifying Windows files and repairing corrupt or `n     damaged Windows operating system files. This ususally resolves common Windows issues with the taskbar, slow performance, or startup issues."
    Write-Host "`n 4. Printer Detection`n    - Detects the physical location of the machine and automatically configures available printers at your location."
    Write-Host "`n 5. ReBit`n   - Recover the BitLocker PIN needed to start your machine."
    Write-Host "`n Q. Close Application`n"
}

#Present the Menu
do
{
    Show-Menu
    $selection = Read-Host "Select an Option"
    switch ($selection)
    {  
        '1' { #Network Rejack Utilities
            Clear-Host
            Write-Host '================ Network Rejack ================'
            Start-Sleep -Seconds 3
            Write-Host "Network Rejack will simulate removing all Ethernet and Wi-Fi connections."
            Start-Sleep -Seconds 5
            Write-Host "**You must notify an IT staff member to process an account unlock before using this utility!**"
            
            do {
                $choice = Read-Host = "Proceed? (Y/N)"
                switch ($choice)
                { 'y'
                   {  # Get all network adapters with a connection
                      $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.LinkSpeed -gt 0 }

                      # Disable adapters that are connected to an Unidentified Network
                      foreach ($adapter in $adapters) {
                      $network = Get-NetConnectionProfile -InterfaceIndex $adapter.ifIndex
                      # Check if the network is Unidentified, if so, disable it
                      if ($network.NetworkCategory -eq 'Unidentified') {
                      Write-Host "Disabling Ethernet... - $($adapter.Name)..."
                      Disable-NetAdapter -Name $adapter.Name -Confirm:$false

                      #Disable all Wireless, wait ten seconds before reenabling all adaptors
                      Write-Host "Engaging Airplane Mode to disable wireless communications..."
                      Set-AirplaneMode -Enabled $true
                      Start-Sleep -Seconds 10

                      Set-AirplaneMode -Enabled $false
                      $disabledAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Disabled' }
                      foreach ($adapter in $disabledAdapters) {
                      Write-Host "Re-enabling adapter... $($adapter.Name)..."
                      Enable-NetAdapter -Name $adapter.Name
                    } 
                { 'n'
                    { #Cancel!
                      Write-Host "Cancelled. Returning to the main menu."
                      Start-Sleep -Seconds 3
                      return
                    }
                }
               
               
             
    }
}
        }
    
        '2' { #Fix My IP Utilties
            Write-Host 'Starting Fix My IP...'
            Start-Sleep -Seconds 3
            Clear-Host
            Write-Host "Fix My IP Utility`n"
            Write-Host "Fix My IP will try to correct the IP address for your machine."
            Write-Host "**SAFE HARBOR MEMBERS**: If you are working Remote, you MUST connect to Sophos VPN before proceeding."
            Start-Sleep -Seconds 3

            #Prepare for entry, false makes sure proceed menu expects Y/N. Change only to true if valid option is typed.
            $isValid = 'false'

            do { #Loop inside of menu loop for getting the okay to proceed - Check for response to proceed with FixMyIP
                $choice = Read-Host "Proceed? (Y\N)"
                switch ($choice)
                { 
                    'y' 
                    { #Run the FixMyIP.exe
                        Write-Host "FixMyIP is running..."
                        Start-Sleep -Seconds 10
                        Write-Host "Scripts ran, returning to main menu."
                        return
                    }
    
                    'n'
                    { #Cancel the procedure
                        Write-Host "Cancelled. Returning to main menu."
                        Start-Sleep -Seconds 3
                        return
                    }

                    'default' 
                    { #You dun goofed.
                        Write-Host "Invalid option entered."
                    }    
                }
            }
            while ($isValid -eq 'false')
        }
    
        'Q' { #Exit
            Write-Host 'Exiting application...'
        }
    }
    pause
}
until ($selection -eq 'q')