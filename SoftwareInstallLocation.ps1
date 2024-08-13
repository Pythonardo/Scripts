#Use this script to output a txt file showing if computers have a file/folder at a specific location

#Filtering what computers to loop through. To loop through all machines change -like to '*'
$computerlist = Get-ADComputer -Filter { (Name -like "ADM-*") -or (Name -like "*MGT*") -and (Name -notlike "ADM-CUBE*") -and (Name -notlike "ADM-SH*") } -SearchBase "OU=Domain-Computers,DC=partnercoloradocu,DC=org"

$report = 
foreach ($computer in $computerlist) {
    Write-verbose "Working on $($computer.Name)" -verbose
    $isUP = Test-Connection -ComputerName $computer.Name -Count 2 -Quiet
    if ($isUP) {
        $test = $null
        #Set the Test-Path location here 
        $test = Invoke-Command -ComputerName $computer.Name -ScriptBlock { Get-ChildItem -Path 'C:\Program Files (x86)', 'C:\Program Files' -Include EXCEL.EXE -Recurse } 
        [pscustomobject]@{
            ComputerName = $computer | Select-Object -ExpandProperty Name
            HasFile      = if ($test) { $test }else { 'False' }
            Status       = 'Up'
        }
    }
    else {
        [pscustomobject]@{
            ComputerName = $computer | Select-Object -ExpandProperty Name
            HasFile      = '-'
            Status       = 'Down'
        }
    }
}

#Set file name and output location here
$report | 
export-csv "\\fs1\IT\Powershell Reports from SAW1\ExcelLocationsReport.csv" -notypeinformation

