# Set the source and destination folders
$source = "\\fs1\IT\COOP FTP FILES\COOP FTP FILES\Partner Colorado CU\"

$currentYear = (Get-Date).ToString("yyyy")
$currentYearFolder = Join-Path $source $currentYear

if (-Not (Test-Path $currentYearFolder)) {
    New-Item -ItemType Directory -Path $currentYearFolder
}

$currentMonth = (Get-Date).ToString("MMMM")
$currentMonthFolder = Join-Path $currentYearFolder $currentMonth

if (-Not (Test-Path $currentMonthFolder)) {
    New-Item -ItemType Directory -Path $currentMonthFolder
}

$currentDay = (Get-Date).ToString("dd")
$currentDayFolder = Join-Path $currentMonthFolder $currentDay

if (-Not (Test-Path $currentDayFolder)) {
    New-Item -ItemType Directory -Path $currentDayFolder
}

#Get a list of all .txt files in the source folder
$txtFiles = Get-ChildItem $source -Filter *.txt

#Loop through each .txt file
foreach ($txtFile in $txtFiles)
{
    #Delete the .txt files from the previous day
    Remove-Item $txtFile.FullName $source
}

# Get a list of all .zip files in the source folder
$zipFiles = Get-ChildItem $source -Filter *.zip

# Loop through each .zip file
foreach ($zipFile in $zipFiles)
{
    # Extract the .zip file to the destination folder
    Expand-Archive $zipFile.FullName $source
    
    # Move the .zip file to the destination folder
    Move-Item $zipFile.FullName $currentDayFolder
}

# Get a list of all .zip files in the source folder
$zipFiles = Get-ChildItem $source -Filter *.zip

# Loop through each .zip file
foreach ($zipFile in $zipFiles)
{
    # Extract the .zip file to the destination folder
    Expand-Archive $zipFile.FullName $source

    # Move the .zip file to the destination folder
    Move-Item $zipFile.FullName $currentDayFolder
}