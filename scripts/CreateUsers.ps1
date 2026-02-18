# Create org unit called LabUsers
New-ADOrganizationalUnit -Name "LabUsers" -Path "DC=doa,DC=local"

$ADUsers = Import-csv c:\AD-LabUsers.csv
foreach ($User in $ADUsers) {
    $Username = $User.SamAccount
    $Password = $User.Password
    $Firstname = $User.Firstname
    $Lastname = $User.Lastname
    $Path = "OU=LabUsers,DC=doa,DC=local"
    
    # Check if user exists
    if (Get-ADUser -Filter {SamAccountName -eq $Username} -ErrorAction SilentlyContinue) {
        Write-Warning "A User exists with that username already: $Username"
    } else {
        New-ADUser -SamAccountName $Username `
            -UserPrincipalName "$Username@doa.local" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $true `
            -DisplayName "$Lastname, $Firstname" `
            -Path $Path `
            -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
            -ChangePasswordAtLogon $false
    }
}