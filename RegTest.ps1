New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS

$SIDs = Get-ChildItem -Path HKU:\ -Name | Where-Object { ($_.Length -gt 8) -and ($_ -NotLike '*Classes*')}

ForEach($user in ($SIDs))
{
    If((Get-ItemPropertyValue "HKU:\$($user)\Software\Microsoft\Avalon.Graphics" -Name DisableHWAcceleration -ErrorAction SilentlyContinue) -Eq 1)
    {
        Write-Host 'HW Acceleration is OFF'
    }
    Else
    {
        Write-Host 'HW Acceleration is not ON'
    }
}

Remove-PSDrive -Name HKU