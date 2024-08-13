$BLV = Get-BitLockerVolume -MountPoint "C:"
Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[2].KeyProtectorId