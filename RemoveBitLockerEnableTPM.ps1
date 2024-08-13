$BLV = Get-BitLockerVolume -MountPoint "C:"
try {
    $everything_is_ok = $true
    Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId -ErrorAction Stop -ErrorVariable x
} catch {
    $everything_is_ok = $false
    Write-Warning "Error no ID at array [1] : $x"

}
try {
    $everything_is_ok = $true
    Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[0].KeyProtectorId -ErrorAction Stop -ErrorVariable x
} catch {
    $everything_is_ok = $false
    Write-Warning "Error no ID at array [0] : $x"
}
try {
    $everything_is_ok = $true
    Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[2].KeyProtectorId -ErrorAction Stop -ErrorVariable x
} catch {
    $everything_is_ok = $false
    Write-Warning "Error no ID at array [2] : $x"
}
Add-BitLockerKeyProtector -MountPoint "C:" -TpmProtector