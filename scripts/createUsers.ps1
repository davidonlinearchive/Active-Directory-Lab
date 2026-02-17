ADUsers = Import-csv c:\AD-LabUsers.csv


foreach ($User in $ADUsers) {

Username = $user.username
Password = $user.password
Firstname = $user.Firstname
Lastname = $user.Lastname
email = $user.email
}


# Check if user exists
if (Get-ADUser -F {SamAccountName -eq $Username}) {
    Write-Warning " A User exists with that username already."
} else {
    New-ADUser SamAccountName $username UserPrinicipalName $Username@doa.local
    "$Firstname $Lastname" GivenName $Firstname $Lastname Enabled $True DisplayName "$Lastname, $Firstname"
    Path $OU City $city Company $Company State $State StreetAddress $
    AccountPassword (convertto-securestring $Password -AsPlainText Force)


}