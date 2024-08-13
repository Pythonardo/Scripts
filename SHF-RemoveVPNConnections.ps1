#Script to delete all PTR and A records for SHF VPN Zone, 10.149.83.*

# Set the name of your DNS zone and the name of your DNS server
$reverseZoneName = "83.149.10.in-addr.arpa"
$forwardZoneName = "shfinancial.org"
$zoneDNSServer = "DC2"

# Get all A records and PTR records in the specified zone
$aRecordsToDelete = Get-DnsServerResourceRecord -ZoneName $dnsZone -RRType A | Where-Object {$_.RecordData.IPv4Address.IPAddressToString.StartsWith("10.149.83")}
$ptrRecordsToDelete = Get-DnsServerResourceRecord -ZoneName $reverseZoneName -RRType Ptr -ComputerName $zoneDNSServer

#Delete records
$aRecordsToDelete | Remove-DnsServerResourceRecord -ZoneName $forwardZoneName -Force
$ptrRecordsToDelete | Remove-DnsServerResourceRecord -ZoneName $reverseZoneName -Force