

function Get-CurrentUser() {
    try { 
        $currentUser = (Get-Process -IncludeUserName -Name explorer | Select-Object -First 1 | Select-Object -ExpandProperty UserName).Split("\")[1] 
    } 
    catch { 
        Write-Output "Failed to get current user." 
    }
    if (-NOT[string]::IsNullOrEmpty($currentUser)) {
        Write-Output $currentUser
    }
}
function Get-UserSID([string]$fCurrentUser) {
    try {
        $user = New-Object System.Security.Principal.NTAccount($currentUser) 
        $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]) 
    }
    catch { 
        Write-Output "Failed to get current user SID."   
    }
    if (-NOT[string]::IsNullOrEmpty($sid)) {
        Write-Output $sid.Value
    }
}
$currentUser = Get-CurrentUser
$currentUserSID = Get-UserSID $currentUser
$userRegistryPath = "Registry::HKEY_USERS\$($currentUserSID)\SOFTWARE\Microsoft\Office\16.0\Outlook\AutoDiscover"

if (-Not (Test-Path $userRegistryPath)) {
    New-Item -ItemType Directory -Path $userRegistryPath
}

New-ItemProperty -Path $userRegistryPath -Name "ExcludeExplicitO365Endpoint" -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $userRegistryPath -Name "EnableOffice365ConfigService" -Value 1 -PropertyType DWORD -Force | Out-Null