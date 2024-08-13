$Trigger= New-ScheduledTaskTrigger -At 10:00am -Daily
$User= "NT AUTHORITY\SYSTEM"
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "\\fs1\Utility\IT\Software\Scripts\StartupSpark.ps1"
Register-ScheduledTask -TaskName "StartupSparkScript" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force