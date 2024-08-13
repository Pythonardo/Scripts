###########################################################  
# AUTHOR  : Marius / Hican - http://www.hican.nl - @hicannl   
# DATE    : 05-07-2012   
# COMMENT : Scan for *.txt files recursively in the root 
#           directory of the script. Compare the contents 
#           of these files to an array of strings, which 
#           are listed in the control file. Output the 
#           successful results to the output file. 
########################################################### 
 
#ERROR REPORTING ALL 
#Set-StrictMode -Version latest 
 
$path     = "C:\temp"
$output   = "C:\System Scripts\output.log" 

$regExCred = 'Total.+Credit.+:.+\$(\d+\,\d+\.\d{1,2})'
$regExDeb = 'Total.+Debit.+:.+\$(\d+\,\d+\.\d{1,2})'
$files    = Get-Childitem $path *.txt -Recurse | Where-Object { !($_.psiscontainer) } 
[System.Collections.ArrayList]$creditArray = $credits
[System.Collections.ArrayList]$debitArray = $debits
 
# Loop through all *.txt files in the $path directory 
Foreach ($file In $files) { 
  # Search file for Credit & Debit Totals
  $credit = Select-String -Path $file -Pattern $regExCred -AllMatches 
  If ($credit) {
    $cred2 = ("$credit" -split '.*\$')
    $creditArray.Add("$cred2")
  }
  $debit = Select-String -Path $file -Pattern $regExDeb -AllMatches
  If ($debit) {
    $deb2 = ("$debit" -split '.*\$')
    $debitArray.Add("$deb2")
  }
} 
If ($creditArray) {
    $creditCompare = @{}
    $creditArray | Foreach { $creditCompare["$_"] +=1 }
    $creditCompare.Keys | Where {$creditCompare["$_"] -gt 1} | Foreach { Write-Host "Credit Totals Match $_" }
} Else {
    Write-Host "No Credit Totals to compare!"
}
If ($debitArray -ne $null) {
    $debitCompare = @{}
    $debitArray | Foreach { $debitCompare["$_"] +=1 }
    $debitCompare.Keys | Where {$debitCompare["$_"] -gt 1} | Foreach { Write-Host "Debit Totals Match $_" }
} Else {
    Write-Host "No Debit Totals to compare!"
}