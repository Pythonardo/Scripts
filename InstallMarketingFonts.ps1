$ShellObject = New-Object -ComObject shell.application
$Fonts = $ShellObject.NameSpace(0x14)
$FontsToInstallDirectory = "\\fs1\Utility\IT\Software\Standard Software\Fonts\Marketing Fonts\"
$FontsToInstall = Get-ChildItem $FontsToInstallDirectory -Recurse -Include '*.ttf','*.ttc','*.otf'
$Ctr = 1
$Total = $FontsToInstall.Count
ForEach ($F in $FontsToInstall){
    $FullPath = $F.FullName
    $Name = $F.Name
    $UserInstalledFonts = "$ENV:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
    If (!(Test-Path "$UserInstalledFonts\$Name")){
        $Fonts.CopyHere($FullPath)
        Write-Host "[$Ctr of $Total] || Installed Font $Name" -ForegroundColor Cyan
    }
    else{
        Write-Host "[$Ctr of $Total] || Font $Name is already installed" -ForegroundColor Green
    }
    $Ctr++
}