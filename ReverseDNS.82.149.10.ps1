$ZoneName = “82.149.10.in-addr.arpa”
$RecordsPTR = Get-DnsServerResourceRecord -ZoneName $ZoneName -RRType Ptr
# Define arrays, count all pTR records and null loop counters
$PTRRecordsToRemove = @()
$PTRRecordsOK = @()
$PTRCounter = $RecordsPTR.Count
$a,$c = 0
 
$ZoneFirstOctet = $ZoneName.Split(“.”)[1]
$ZoneSecondOctet = $ZoneName.Split(“.”)[0]
 
$PTRCounter
foreach($record in $RecordsPTR){
 
# Convert to IP address
$PTRIP = $ZoneFirstOctet+”.” + $ZoneSecondOctet+”.”
$SPlit = $record.HostName.Split(“.”)
for($i=1;$i -le 3;$i++)
{
$PTRIP +=$SPlit[-$i]+”.”
}
$PTRIP = $PTRIP.Substring(0,$PTRIP.Length-1)
 
Write-Progress -Activity “Processing PTR records” -Status “Percent complete..” -PercentComplete (($a/$PTRCounter) *100)
$DNSName = $record.RecordData.PtrDomainName
$DNSName = $DNSName.substring(0,$DNSName.length-1)
Try
{
$lookup = $null
$DNSName
#Check if for hostname assigned to PTR A record exist
$lookup = [System.Net.Dns]::GetHostAddresses($DNSName)
if($lookup.Count -gt 1)
{
$lookup = $lookup[1].IPAddressToString
 
}
else
{
$lookup = $lookup.IPAddressToString
}
 
}
Catch
{
# If there is no A record for hostname remove PTR record
$PTRRecordsToRemove += $record
}
 
if(![string]::IsNullOrEmpty($lookup))
{
$PTRRecordsOK += $record
 
}
 
$a++
}
 
# Removing wrong PTR records
$PTRRecordsToRemoveCounter = $PTRRecordsToRemove.Count
foreach($PTRRemove in $PTRRecordsToRemove)
{
$c++
Write-Progress -Activity “Checking incorrect PTR records” -Status “Percent complete” -PercentComplete (($c/$PTRRecordsToRemoveCounter)*100)
Try
{
$PTRRemove
}
Catch
{
Write-Host Record for PTR $PTRRemove.HostName – $PTRRemove.RecordData.PtrDomainName already removed -ForegroundColor Yellow
}
}
 
$PTRRecordsOK | out-gridview
$PTRRecordsToRemove | out-gridview
 
Write-Host “———————-”
Write-Host Report:
Write-Host PTR records OK: ($PTRRecordsOK | Sort-Object -Unique -Property HostName).Count
Write-Host PTR records to Remove: $PTRRecordsToRemove.Count
Write-Host “Report files can be found under $env:TEMP”
Write-Host “———————-“