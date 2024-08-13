$OUs=
"OU=Users,OU=CreditUnion,OU=Domain-Users,DC=partnercoloradocu,DC=org",
"OU=Users,OU=IT,OU=Domain-Users,DC=partnercoloradocu,DC=org"

$OUs | Foreach {Get-ADUser -Filter * -Searchbase $_ -Properties *} | Select DisplayName, EmailAddress, Title | Export-Csv "\\fs1\HR\Employee\Email List\Staff_Email_Addresses.csv"