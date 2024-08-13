$BLV = Get-BitlockerVolume -MountPoint "C:"
$TpmPinKeyProtector = $BLV.KeyProtector | Where-Object {$PSItem.KeyProtectorType -eq "TpmPin"}
Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $TpmPinKeyProtector.KeyProtectorId
$PIN = Get-Random -Maximum 999999 -Minimum 111111
$UserPIN = ConvertTo-SecureString "$PIN" -AsPlainText -Force
Add-BitLockerKeyProtector -MountPoint "C:" -TpmAndPinProtector -Pin $UserPIN
Get-ComputerInfo | Select-Object -ExpandProperty CsName  | Out-File -FilePath "\\fs1\IT\Encryption Recovery Key's\PINs\$Env:COMPUTERNAME.txt" -Force
Add-Content -Path "\\fs1\IT\Encryption Recovery Key's\PINs\$Env:COMPUTERNAME.txt" -Value $PIN
$BLV = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object {($_.KeyProtectorType -eq "RecoveryPassword")}
if (-not $BLV) {
    Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector 
} else {
    Write-Host "Recovery Password already exists"
}