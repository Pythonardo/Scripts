#Set variable to check if old PC is a laptop
                $isLaptop = $false
                 if(Get-WmiObject -Class win32_systemenclosure -ComputerName $CurrentPC |
                    Where-Object { $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 `
                    -or $_.chassistypes -eq 14})
                   { $isLaptop = $true }
                 if(Get-WmiObject -Class win32_battery -ComputerName $CurrentPC)
                   { $isLaptop = $true }
                 $isLaptop
                }
                #If PC is a laptop, no IP reservation needed as it is the dock that holds the reservation
                if ($isLaptop) {
                    Write-Output "This is a laptop, no reservation needed"
                }else {
                #If PC is a desktop, check if there is a current reservation
                    Write-Output "This is a desktop, checking reservation"
                
                    #Code to check for reservation and record IP then delete reservation
                    $NetAdapters = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $CurrentPC | ? {$_.DHCPEnabled -eq $True -and $null -ne $_.IPAddress}
                    If ($NetAdapters) {
                        Foreach ($Adapter in $NetAdapters) {
                            foreach ($IP in $Adapter.IPAddress) {
                                try {
                                    $Reservation = Get-DhcpServerv4Reservation -ScopeId $IP -ComputerName $Adapter.DHCPServer | ? {$_.ScopeId -eq $_.IPAddress}
                                    $ReservedIP = $Reservation | Select-Object -ExpandProperty IPAddress | Select-Object -ExpandProperty IPAddressToString
                                    If ($Reservation) {
                                        Write-Output "$IP is reserved on $($Adapter.DHCPServer)."
                                        #Code to delete reservation
                                        try {Remove-DhcpServerv4Reservation -ComputerName $CurrentPC -IPAddress $ReservedIP}
                                        catch {"Not able to remove Reservation for $CurrentPC at $ReservedIP"}
                                    } Else {
                                        Write-Output "$IP does not have a reservation."
                                    }
                                } catch {
                                        ""
                                }
                            }
                        }
                    } Else {
                        Write-Output "No DHCP Enabled NetAdapters with IPAddresses exist on host, likely Static"
                    }
                }