$PIN = Get-Random -Maximum 999999 -Minimum 111111
$UserPIN = ConvertTo-SecureString "$PIN" -AsPlainText -Force
Write-Host "PIN has been set to $UserPIN"
Add-BitLockerKeyProtector -MountPoint "C:" -TpmAndPinProtector -Pin $UserPIN 
$BLV = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object {($_.KeyProtectorType -eq "RecoveryPassword")}
if (-not $BLV) {
    Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector 
} else {
    Write-Host "Recovery Password already exists"
}
Get-ComputerInfo | Select-Object -ExpandProperty CsName  | Out-File -FilePath "\\fs1\IT\Encryption Recovery Key's\PINs\$Env:COMPUTERNAME.txt" -Force
Add-Content -Path "\\fs1\IT\Encryption Recovery Key's\PINs\$Env:COMPUTERNAME.txt" -Value $PIN