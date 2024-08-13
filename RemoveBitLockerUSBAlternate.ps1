$BLV = Get-BitLockerVolume -MountPoint "C:"
Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[0].KeyProtectorId