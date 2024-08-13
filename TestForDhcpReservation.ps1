$ComputerName = "ARV-CALL9"
$NetAdapters = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $ComputerName | ? {$_.DHCPEnabled -eq $True -and $null -ne $_.IPAddress}
If ($NetAdapters) {
    Foreach ($Adapter in $NetAdapters) {
        foreach ($IP in $Adapter.IPAddress) {
            try {
                $Reservation = Get-DhcpServerv4Reservation -ScopeId $IP -ComputerName $Adapter.DHCPServer | ? {$_.ScopeId -eq $_.IPAddress}
                $test = $Reservation | Select-Object -ExpandProperty IPAddress | Select-Object -ExpandProperty IPAddressToString
                If ($Reservation) {
                    Write-Output "$IP is reserved on $($Adapter.DHCPServer)."
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
