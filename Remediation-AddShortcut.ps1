$TargetFile = "C:\Program Files (x86)\Jack Henry & Associates\Episys Quest 3.2022.0.144\QuestLauncher.exe"
$ShortcutFile = "$env:Public\Desktop\Symitar.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()