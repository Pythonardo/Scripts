#Bookmark Backup to H: Drive

#Grab current user as variable
$user = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property username).username
$currentDomainName = $user.split("\")[0]
# Set the variable to the second string after the "\" character
$currentUserName = $user.split("\")[1]

#Google Chrome Backup Bookmarks
if (Test-Path "C:\Users\$currentUserName\AppData\Local\Google\Chrome\User Data\Default\Bookmarks") {
	if (-not (test-path "\\fs1\Home\PCCU\$currentUserName\Backup\Chrome")) { New-Item -Path "\\fs1\Home\PCCU\$currentUserName\Backup\Chrome" -Type Directory -Force:$true }
	Copy-Item -Path "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default\Bookmarks" -Destination "\\fs1\Home\PCCU\$currentUserName\Backup\Chrome" -Force:$true -Confirm:$false
}

#Google Edge Backup Bookmarks
if (Test-Path "C:\Users\$currentUserName\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks") {
	if (-not (test-path "\\fs1\Home\PCCU\$currentUserName\Backup\Edge")) { New-Item -Path "\\fs1\Home\PCCU\$currentUserName\Backup\Edge" -Type Directory -Force:$true }
	Copy-Item -Path "$($env:LOCALAPPDATA)\Microsoft\Edge\User Data\Default\Bookmarks" -Destination "\\fs1\Home\PCCU\$currentUserName\Backup\Edge" -Force:$true -Confirm:$false
}

#Mozilla Firefox Backup Bookmarks
if (Test-Path "C:\Users\$currentUserName\AppData\Local\Mozilla\Firefox\Profiles") {
	if (-not (test-path "\\fs1\Home\PCCU\$currentUserName\Backup\FireFox")) { New-Item -Path "\\fs1\Home\PCCU\$currentUserName\Backup\FireFox" -Type Directory -Force:$true }
	$MozillaPlaces = (get-childitem "$($env:APPDATA)\Mozilla\Firefox\Profiles" -force -recurse -ErrorAction SilentlyContinue | where-object { $_.Name -eq 'places.sqlite' }).DirectoryName
	copy-item -path "$MozillaPlaces" -Destination "\\fs1\Home\PCCU\$currentUserName\Backup\FireFox" -Force:$true -Confirm:$false
}