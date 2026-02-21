# DESCRIPTION: Disables Kerberos Pre-Authentication for 2 randomly selected users in the "LabUsers" OU
# DOMAIN: doa.local


Import-Module ActiveDirectory

# Get all users from the LabUsers OU
$LabUsers = Get-ADUser -Filter * -SearchBase "OU=LabUsers,DC=doa,DC=local" -Properties UserAccountControl

# Pick 2 random users
$TargetUsers = $LabUsers | Get-Random -Count 2


foreach ($User in $TargetUsers) {
    Set-ADAccountControl -Identity $User -DoesNotRequirePreAuth $true
    Write-Host "Disabled Kerberos Pre-Auth for: $($User.SamAccountName)"
}