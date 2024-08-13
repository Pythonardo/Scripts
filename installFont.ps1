
$FontFolder = "\\fs1\Utility\IT\Software\Standard Software\Fonts\All Windows Fonts"

$Fonts = Get-ChildItem -Path $FontFolder 
ForEach ($Font in $Fonts) {
    Copy-Item -Path $FontFolder -Destination "C:\Windows\Fonts" -Force
}
New-ItemProperty -Name $Font -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType String -Value $Font -Force