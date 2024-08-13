#Adding UGeniusReceipt printer for NCR

#Checking for and adding temp folder and receipt.txt file
Test-Path -Path "c$\temp\receipt.txt"
if(-Not (Test-Path -Path "c$\temp\receipt.txt")) {
    New-Item -ItemType Directory -Path "c:\temp"
    New-Item -ItemType File -Path "c:\temp\" -Name "receipt.txt"
}

#Adding UGeniusReceipt printer
Add-PrinterDriver -Name "Generic / Text Only"
Add-PrinterPort -Name "c:\temp\receipt.txt"
Add-Printer -Name "UGeniusReceipt" -DriverName "Generic / Text Only" -PortName "c:\temp\receipt.txt"