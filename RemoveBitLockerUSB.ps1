
$BLV = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object {($_.KeyProtectorType -eq "TPM And Startup Key")} | Select-Object -ExpandProperty KeyProtectorId
Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV
Add-BitLockerKeyProtector -MountPoint "C:" -TpmProtector
$BLV = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object {($_.KeyProtectorType -eq "RecoveryPassword")}
if (-not $BLV) {
    Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector 
} else {
    Write-Host "Recovery Password already exists"
}