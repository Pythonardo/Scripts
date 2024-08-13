#Rename old and new computers
Write-Host "PCCU Workstation Renamer"

#Get the name of the Target and confirm it
$CurrentPC = Read-Host "Enter the name of the OLD computer"
$Response = Read-Host "Is this correct? ($CurrentPC) `Y / N" 
#Try block to make sure current (old) PC name exists
try {
    $test = Get-ADComputer -Identity $CurrentPC -ErrorAction Stop
    #If current PC name is found, prompt for new PC current name and confirm it
    if ($test) {
        $NewPC = Read-Host "Enter the current name of the NEW computer"
        $Response1 = Read-Host "Is this correct? ($NewPC) `Y / N"
        #Try block to make sure new PC name exists
        try {
            $test1 = Get-ADComputer -Identity $NewPC -ErrorAction Stop
            #If new PC name is also found in AD, proceed
            if (($test1) -and ($Response -eq "y") -and ($Response1 -eq "y")) {
                #Set variable for new name for old PC
                $OldPCNewName = "$CurrentPC-O"
                Write-Host "Old PC will be renamed to $OldPCNewName"
                
                #Rename old PC
                Rename-Computer -ComputerName $CurrentPC -NewName $OldPCNewName -Restart -Force -DomainCredential Get-Credential
                #Attempt to wait for old PC to become online again
                If (Test-Connection -ComputerName $OldPCNewName -Count 5 -Delay 5 -Quiet) {
                    Write-Host "New PC will be renamed to $CurrentPC"
                    #Code to make new reservation with saved IP
                    if ($ReservedIP) {
                        $ClientID = Get-WmiObject win32_networkadapterconfiguration -ComputerName $NewPC | Where-Object -Property IPAddress -ne $null
                        try {
                            Add-DhcpServerv4Reservation -ScopeId 10.200.0.222 -IPAddress $ReservedIP -ComputerName $CurrentPC -ClientId $ClientID -Description "$CurrentPC"
                        }
                        catch {
                            "Not able to make a Reservation for $CurrentPC at IP $ReservedIP"
                        }
                    }
                    #Rename new PC to the original PC name
                    Rename-Computer -ComputerName $NewPC -NewName $CurrentPC -Restart -Force -DomainCredential Get-Credential
                }
            }
        } catch {
            Write-Output "$NewPC does not exist in AD"
        }
    }
} catch {
    Write-Output "$CurrentPC does not exist in AD"
}
