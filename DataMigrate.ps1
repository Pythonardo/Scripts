Write-Host "PCCU Profile Migrator"

#Get the name of the Target and confirm it
$TargetComputer = Read-Host "Enter the name of the TARGET computer to copy the files to"
$Response = Read-Host "Is this correct? ($TargetComputer) `Y / N" 
$SourceComputer = Read-Host "Enter the name of the SOURCE computer to copy the files from"
$Response1 = Read-Host "Is this correct? ($SourceComputer) `Y / N"
    If(($Response -eq "y") -and ($Response1 -eq "y")) #Proceed
    {
        $path = "\\$SourceComputer\C$\Users\"
        $SourceUser = Get-ChildItem -Path $path -Filter $_.Name -Exclude "Administrator", "pdqsa", "Public", "matthewhorine", "lyndonnicholas" | Select-Object -Property Name
        Write-Host $SourceUser

        $SourceUser = Read-Host "Enter the name of the user to migrate"
    
    } else {
    
    }

#Final check before import
$Confirmation = Read-Host "$SourceComputer $SourceUser's profile data will be imported to $TargetComputer nWARNING: Existing files/folders will be overwritten! ` Proceed? Y / N"
    If($Confirmation -eq "y") #Proceed
    {
        #Directories from the source's profile folder to copy
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\Desktop\") {
            Write-Host "Copying Desktop items"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\Desktop\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\Desktop\" -Recurse -Force
        }

        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\Documents\") {
            Write-Host "Copying Documents"
            Copy-Item -Path "\\$SourceCompute\c$\Users\$SourceUser\Documents\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\Documents\" -Recurse -Force
        }

        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\Downloads\") {
            Write-Host "Copying Downloads"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\Downloads\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\Downloads\" -Recurse -Force
        }

        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\Favorites\") {
            Write-Host "Copying Favorited items"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\Favorites\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\Favorites\" -Recurse -Force
        }

        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\Links\") {
            Write-Host "Copying Bookmarks"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\Links\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\Links\" -Recurse -Force
        }

        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\Pictures\") {
            Write-Host "Copying Pictures"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\Pictures\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\Pictures\" -Recurse -Force
        }

        #Directories from the source's AppData folder to copy

        Write-Host "Copying Web Browser data"

        #Google Chrome
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Google\Chrome\User Data\Default") {
            Write-Host "Google Chrome"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Google\Chrome\User Data\Default" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\Google\Chrome\User Data\Default" -Recurse -Force
        }

        #Internet Explorer
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Internet Explorer\") {
            Write-Host "Internet Explorer"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Internet Explorer\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Internet Explorer\" -Recurse -Force
        }

        #Edge
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Edge\") {
            Write-Host "Microsoft Edge"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Edge\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Edge\" -Recurse -Force
        }

        #Firefox
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Mozilla\Firefox\Profiles\") {
            Write-Host "Mozilla Firefox"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Mozilla\Firefox\Profiles\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\Mozilla\Firefox\Profiles\" -Recurse -Force
        }

        #Brave
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\BraveSoftware\Brave-Browser\User Data\") {
            Write-Host "Brave"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\BraveSoftware\Brave-Browser\User Data\" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\BraveSoftware\Brave-Browser\User Data\" -Recurse -Force
        }

        #Outlook
        #Navigation Pane
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\Outlook\*.xml") {
            Write-Host "Outlook Navigation Pane Settings"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\Outlook\*.xml" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\Outlook\" -Force
        }
        #Signatures
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\Signatures") {
            Write-Host "Outlook Signatures"
            Copy-item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\Signatures" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\Signatures" -Force
        }
        #Dictionary
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\UProof") {
            Write-Host "Outlook Dictionary"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\UProof" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Roaming\Microsoft\UProof" -Force
        }
        #.ost
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Outlook\*.ost") {
            Write-Host "Outlook .ost file"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Outlook\*.ost" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Outlook\" -Force
        }
        #.pst
        If(Test-Path -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Outlook\*.pst") {
            Write-Host "Outlook .pst file"
            Copy-Item -Path "\\$SourceComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Outlook\*.pst" -Destination "\\$TargetComputer\c$\Users\$SourceUser\AppData\Local\Microsoft\Outlook\" -Force
        }
}
Write-Host "Migration has been completed"