
# Install DHCP role
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Authorize DHCP server in AD
Add-DhcpServerInDC -DnsName "DC.doa.local" -IPAddress 10.0.2.10

# Create DHCP scope
Add-DhcpServerv4Scope `
    -Name "Lab-Scope" `
    -StartRange 10.0.2.100 `
    -EndRange 10.0.2.200 `
    -SubnetMask 255.255.255.0 `
    -State Active

# Set Gateway option
Set-DhcpServerv4OptionValue -ScopeId 10.0.2.0 -Router 10.0.2.1

# Set DNS option
Set-DhcpServerv4OptionValue -ScopeId 10.0.2.0 -DnsServer 10.0.2.7 -DnsDomain "doa.local"

# Exclude DC IP from DHCP pool
Add-DhcpServerv4ExclusionRange -ScopeId 10.0.2.0 -StartRange 10.0.2.1 -EndRange 10.0.2.50

# Verify DHCP configuration
Get-DhcpServerv4Scope