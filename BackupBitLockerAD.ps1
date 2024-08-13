#Finding which Key Protector ID is set to the RecoveryPassword
$BLV = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object {($_.KeyProtectorType -eq "RecoveryPassword")} | Select-Object -ExpandProperty KeyProtectorId
#Backing up password and Identifier to AD
manage-bde -protectors -adbackup c: -Id $BLV