Add-BitLockerKeyProtector -MountPoint "C:" -TpmAndStartupKeyProtector  -StartupKeyPath "D:"
try {
    Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector -ErrorAction Stop -ErrorVariable x
    } catch {
        Write-Warning "Recovery password already exists : $x"
    }

$BLV = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object {($_.KeyProtectorType -eq "RecoveryPassword")}
if (-not $BLV) {
    Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector 
} else {
    Write-Host "Recovery Password already exists"
}