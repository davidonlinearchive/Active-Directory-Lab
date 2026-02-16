# Install Active Directory
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Set DC name
Install-ADDSDomainController -DomainName "doa.local" -InstallDns -Credential (Get-Credential) -Confirm:$false

