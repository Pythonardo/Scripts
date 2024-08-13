# Set the source and destination folders
$source = "\\fs1\IT\COOP FTP FILES\COOP FTP FILES\Partner Colorado CU"

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

#Delete all .txt from previous run
Get-ChildItem -Path $source *.txt | foreach { Remove-Item -Path $_.FullName }

# Get a list of all .zip files in the source folder
$zipFiles = Get-ChildItem $source -Filter *.zip

#Expand Files.zip file and move items to folder for current day
Get-ChildItem -Path $source -Filter *.zip | Expand-Archive -DestinationPath $currentDayFolder -Force

#Expand folders from current day and move back to source folder
Get-ChildItem -Path $currentDayFolder *.zip | Expand-Archive -DestinationPath $source -Force

#Move Files.zip to current day folder
Get-ChildItem -Path $source -Filter *.zip | Move-Item -Destination $currentDayFolder -Force