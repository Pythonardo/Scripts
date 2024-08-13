#Set folder to IT drive
$files = "\\fs1\IT\swbc\2022\"

#Create date append variable
$dateString = (Get-Date).ToString("MMdd")

#Loop through and only rename if needed
Get-ChildItem -Path $files -File | Rename-Item -NewName {
    if ($_.Name -eq ("ECM_1343")) {
        "ECM_1343_$dateString"
        }
    else {
        $_.Name
         }
    }

#Set path to Symitar drive
$items = "\\fs1\Symitar\Partner\ECM\"

#Loop through and only rename if needed
Get-ChildItem -Path $items -File | Rename-Item -NewName {
    if ($_.Name -eq ("ECM_1343")) {
        $_.Name
        }
    else {
        "ECM_1343"
         }
    }

#Move file from Symitar drive to IT drive
Move-Item -Path "\\fs1\Symitar\Partner\ECM\ECM_1343" -Destination "\\fs1\IT\swbc\2022\"