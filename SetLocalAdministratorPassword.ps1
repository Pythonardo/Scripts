$Password = ConvertTo-SecureString "L0c@l@dm1n6221" -AsPlainText -Force
$UserAccount = Get-LocalUser -Name "PCCU-Admin"
$UserAccount | Set-LocalUser -Password $Password