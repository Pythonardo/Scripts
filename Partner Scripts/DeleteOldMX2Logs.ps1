#Script to delete files over 30 days old from MX2 logs

#Parameters
$Path = "\\MX2\C$\inetpub\logs\LogFiles\W3SVC1" # Path where the file is located 
$Path2 = "\\MX2\C$\inetpub\logs\LogFiles\W3SVC2"
$Days = "30" # Number of days before current date
 
#Calculate Cutoff date
$CutoffDate = (Get-Date).AddDays(-$Days)
 
#Get All Files modified more than the last 30 days
Get-ChildItem -Path $Path -Recurse -File | Where-Object { $_.LastWriteTime -lt $CutoffDate } | Remove-Item –Force -Verbose
Get-ChildItem -Path $Path2 -Recurse -File | Where-Object { $_.LastWriteTime -lt $CutoffDate } | Remove-Item –Force -Verbose