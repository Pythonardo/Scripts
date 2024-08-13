#!powershell

# Setup Key Values
###################################
$computername = "$env:computername"

 

# Rename Local Administrator Account  
###################################
$ErrorActionPreference = "Stop"

#!powershell

# Setup Key Values
###################################
$computername = “$env:computername”

 

# Rename Local Administrator Account  
###################################
$ErrorActionPreference = “Stop”

# Create computer object
$computer = [ADSI](“WinNT://$computerName,computer”)

# Get local users list
$userList = $computer.psbase.Children | Where-Object { $_.psbase.schemaclassname -eq ‘user’ }

foreach ($user in $userList)
  {
   # Create a user object in order to get its SID
   $userObject = New-Object System.Security.Principal.NTAccount($user.Name)

   write-host ” ”
   write-Host “UserObject $userObject” -ForegroundColor Green
   write-host ” “

   $userSID = $userObject.Translate([System.Security.Principal.SecurityIdentifier])

   # Look for local “Administrator” SID
   if(($userSID.Value.substring(0,6) -eq “S-1-5-“) -and ($userSID.Value.substring($userSID.Value.Length – 4, 4) -eq “-500”))
      {
      # Rename local Administrator account to PCCU-Admin
      $Error.Clear()
      try
          {
            Write-Host “Rename Local Administrator account to PCCU-Admin” -ForegroundColor Green
            $localAdmin=[adsi]”WinNT://./$userObject,user”
            $localAdmin.psbase.rename(‘PCCU-Admin’)
          }
      catch [System.UnauthorizedAccessException]         {
           Write-Host “Access Denied” -ForegroundColor Red
         }
     }
 }
