# Active Directory Penetration Testing Lab

![Lab Status](https://img.shields.io/badge/Status-Operational-success)
![Domain](https://img.shields.io/badge/Domain-doa.local-blue)
![VMs](https://img.shields.io/badge/VMs-4-orange)

## 📋 Project Overview

A fully functional Active Directory (AD) cybersecurity laboratory environment built on VirtualBox to simulate enterprise infrastructure for offensive security research, penetration testing practice, and BloodHound attack methodology training.

**Domain:** `doa.local`  
**Network:** Custom NAT Network (10.0.2.0/24)  
**Purpose:** AD enumeration, privilege escalation, and lateral movement testing

---

## 🏗️ Lab Architecture

### Network Topology
```
                    INTERNET
                       ↓
        ┌──────────────────────────┐
        │  VirtualBox NAT Gateway  │
        │       10.0.2.1           │
        └──────────────────────────┘
                       ↓
        ┌──────────────────────────┐
        │  Custom NAT Network      │
        │  "AD-Lab"                │
        │  10.0.2.0/24             │
        └──────────────────────────┘
              ↓       ↓       ↓       ↓
        ┌─────────┐ ┌─────┐ ┌─────┐ ┌──────┐
        │   DC    │ │Win10│ │Win10│ │ Kali │
        │10.0.2.10│ │.100 │ │.101 │ │.250  │
        └─────────┘ └─────┘ └─────┘ └──────┘
```

### Virtual Machines

| VM Name | OS | IP Address | Role | Specs |
|---------|-----|-----------|------|-------|
| **DOA-DC** | Windows Server 2019 | 10.0.2.10 (static) | Domain Controller | 2GB RAM, 50GB HDD |
| **Client-01** | Windows 10/11 Pro | 10.0.2.100 (DHCP) | Domain-joined client | 2GB RAM, 40GB HDD |
| **Client-02** | Windows 10/11 Pro | 10.0.2.101 (DHCP) | Domain-joined client | 2GB RAM, 40GB HDD |
| **Kali-Attack** | Kali Linux 2024.x | 10.0.2.250 (static) | Attack platform | 4GB RAM, 80GB HDD |

---

## 🔧 Technical Implementation

### Domain Controller Configuration

**Roles & Services:**
- Active Directory Domain Services (AD DS)
- DNS Server with forwarder (10.0.2.3 → VirtualBox DNS)
- DHCP Server (Scope: 10.0.2.100-200)
- Domain: `doa.local` (NetBIOS: `DOA`)

**Key Settings:**
```powershell
# Static IP Configuration
IP:      10.0.2.10/24
Gateway: 10.0.2.1
DNS:     10.0.2.10 (itself)

# DHCP Scope
Range:   10.0.2.100 - 10.0.2.200
Gateway: 10.0.2.1
DNS:     10.0.2.10
Domain:  doa.local
```

### Network Configuration

**VirtualBox Setup:**
- Network Type: Custom NAT Network
- Network Name: `AD-Lab`
- IPv4 CIDR: `10.0.2.0/24`
- VirtualBox DHCP: Disabled (DC provides DHCP)
- Internet Access: Automatic via VirtualBox NAT gateway (10.0.2.1)

**Why This Design:**
- ✅ No RRAS/routing configuration needed
- ✅ VirtualBox handles all NAT automatically
- ✅ Single NIC per VM (simplified topology)
- ✅ Complete isolation from host network
- ✅ All VMs have internet access
- ✅ Realistic AD environment

---

## 👥 Active Directory Population

### User Accounts (10 total)

Created via PowerShell automation script from CSV import:

| Username | Full Name | Password | OU |
|----------|-----------|----------|-----|
| imak | Islam Makhachev | admin | OU=LabUsers |
| top | Ilia Topuria | Elmatador1 | OU=LabUsers |
| kchimaev | Khamzat Chimaev | Borz7 | OU=LabUsers |
| volk | Alex Volkanovski | TheGreat123 | OU=LabUsers |
| poatan | Alex Pereira | PoatanChama3 | OU=LabUsers |
| mdew | Merab Dewey | Machine400 | OU=LabUsers |
| pyan | Petr Yan | NoMercy05 | OU=LabUsers |
| ujack | Tom Aspinall | Changeme123! | OU=LabUsers |
| alex.pan | Alessandre Pantoja | Cannibal | OU=LabUsers |
| holloway | Max Holloway | BlessedExpress0 | OU=LabUsers |

### Organizational Structure
```
doa.local
  └── LabUsers (OU)
       ├── imak
       ├── top
       ├── kchimaev
       └── ... (other users)
```

---

## 🔴 Attack Platform (Kali Linux)

### Tools Installed

| Tool | Purpose | Installation |
|------|---------|--------------|
| **BloodHound** | AD enumeration & attack path analysis | `sudo apt install bloodhound` |
| **Neo4j** | Graph database for BloodHound | `sudo apt install neo4j` |
| **Impacket** | Python AD toolkit | Pre-installed |
| **Responder** | LLMNR/NBT-NS poisoning | Pre-installed |
| **CrackMapExec** | AD Swiss army knife | `sudo apt install crackmapexec` |
| **Hashcat** | Password cracking | Pre-installed |

### Network Configuration
```bash
# Static IP Setup
IP:      10.0.2.250/24
Gateway: 10.0.2.1
DNS:     10.0.2.10 (DC)

# Promiscuous Mode: Enabled (for packet capture)
```

---

## 🎯 Attack Capabilities

### Enumeration
- [x] BloodHound/SharpHound AD mapping
- [x] LDAP enumeration
- [x] DNS zone enumeration
- [x] SMB share discovery
- [x] User/group enumeration

### Credential Attacks
- [x] Kerberoasting (service account hash extraction)
- [x] AS-REP Roasting (no pre-auth users)
- [x] Password spraying
- [x] LLMNR/NBT-NS poisoning (Responder)
- [x] SMB relay attacks
- [x] Pass-the-Hash

### Privilege Escalation
- [x] BloodHound attack path analysis
- [x] ACL abuse
- [x] Golden Ticket attacks (krbtgt hash)
- [x] DCSync attacks
- [x] Unconstrained delegation exploitation

### Lateral Movement
- [x] PSExec
- [x] WMIExec
- [x] Pass-the-Hash lateral movement
- [x] Credential dumping (Mimikatz-style)

---

## 📊 Lab Statistics

- **Setup Time:** ~2 hours (first build)
- **VMs:** 4 total (1 DC, 2 clients, 1 attacker)
- **Domain Users:** 10 accounts
- **Network Subnet:** 10.0.2.0/24
- **Total Storage:** ~210GB allocated
- **Total RAM:** 10GB allocated

---

## 🚀 Quick Start Guide

### 1. VirtualBox Network Setup
```bash
# Create NAT Network
VirtualBox → Tools → Network Manager → NAT Networks
Name: AD-Lab
CIDR: 10.0.2.0/24
DHCP: Disabled
```

### 2. Configure All VMs
```
Each VM → Settings → Network → Adapter 1
Attached to: NAT Network
Name: AD-Lab
```

### 3. Deploy Domain Controller
```powershell
# Set static IP
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.0.2.10 -PrefixLength 24 -DefaultGateway 10.0.2.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.0.2.10

# Promote to DC
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "doa.local" -DomainNetbiosName "DOA" -InstallDns:$true -Force:$true

# After reboot - configure DNS forwarder
Add-DnsServerForwarder -IPAddress 10.0.2.3

# Install & configure DHCP
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerv4Scope -Name "Lab" -StartRange 10.0.2.100 -EndRange 10.0.2.200 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -Router 10.0.2.1 -DnsServer 10.0.2.10
```

### 4. Configure Kali
```bash
# Set static IP
sudo ip addr add 10.0.2.250/24 dev eth0
sudo ip link set eth0 up
sudo ip route add default via 10.0.2.1
echo "nameserver 10.0.2.10" | sudo tee /etc/resolv.conf
```

### 5. Join Windows Clients to Domain
```
Settings → System → About → Rename this PC (advanced)
→ Domain: doa.local
→ Credentials: DOA\Administrator
```

### 6. Run BloodHound
```bash
# On Kali
sudo neo4j start
bloodhound-python -d doa.local -u imak -p admin -ns 10.0.2.10 -c all
bloodhound
# Import collected data
```

---

## 🔒 Security Considerations

### What This Lab IS For:
✅ Learning AD attack techniques  
✅ Practicing BloodHound enumeration  
✅ Understanding privilege escalation paths  
✅ Testing defensive measures  
✅ Building penetration testing skills  

### What This Lab is NOT For:
❌ Production use  
❌ Storing real data  
❌ Internet-facing deployment  
❌ Actual business operations  

### Isolation
- Custom NAT Network = isolated from host LAN
- No bridged adapters to physical network
- Internet access via VirtualBox NAT only
- Safe to run malware/attacks without risk to host

---

## 📝 Key Learnings

### Technical Skills Gained
- Active Directory deployment and configuration
- DNS/DHCP server administration
- PowerShell automation scripting
- Virtual network design
- BloodHound attack methodology
- Kerberos authentication exploitation
- Credential harvesting techniques
- Windows Server administration

### Attack Techniques Practiced
- Kerberoasting
- AS-REP Roasting  
- Password spraying
- LLMNR poisoning
- Pass-the-Hash
- Golden Ticket attacks
- DCSync attacks
- Attack path analysis

---

## 🛠️ Troubleshooting

### VMs Can't Communicate
**Problem:** Ping between VMs fails  
**Solution:** 
- Verify all VMs use "NAT Network" (not "NAT")
- Confirm network name is "AD-Lab" on all VMs
- Disable Windows Firewall temporarily for testing

### No Internet Access
**Problem:** VMs can't reach internet  
**Solution:**
- Verify gateway is 10.0.2.1
- Check DNS forwarder on DC: `Get-DnsServerForwarder`
- Test: `ping 8.8.8.8`

### Can't Join Domain
**Problem:** Domain join fails  
**Solution:**
- Verify DNS points to 10.0.2.10 on client
- Test: `nslookup doa.local` (should resolve to DC)
- Check DC firewall allows domain traffic

### DHCP Not Working
**Problem:** Clients don't get IP addresses  
**Solution:**
- Verify VirtualBox DHCP is disabled in NAT Network
- Check DC DHCP scope is Active: `Get-DhcpServerv4Scope`
- Restart DHCP: `Restart-Service DHCPServer`

---

## 📚 Resources & References

### Official Documentation
- [Microsoft AD DS Documentation](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/)
- [BloodHound Documentation](https://bloodhound.readthedocs.io/)
- [Impacket GitHub](https://github.com/fortra/impacket)

### Learning Resources
- [HackTricks - Active Directory](https://book.hacktricks.xyz/windows-hardening/active-directory-methodology)
- [ired.team - AD Notes](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse)
- [PayloadsAllTheThings - AD](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Active%20Directory%20Attack.md)

---

## 📅 Project Timeline

- **Day 1:** VirtualBox network setup, DC deployment
- **Day 2:** AD configuration, DNS/DHCP setup
- **Day 3:** User provisioning, client domain join
- **Day 4:** Kali configuration, BloodHound setup
- **Day 5:** Attack testing and documentation

---

## 🎓 Next Steps

- [ ] Practice Kerberoasting attacks
- [ ] Test AS-REP Roasting
- [ ] Analyze BloodHound attack paths
- [ ] Implement defensive measures (LAPS, MFA)
- [ ] Document attack findings
- [ ] Create defense playbook
- [ ] Add more complex OUs and groups
- [ ] Simulate multi-tier AD environment

---

## 🤝 Contributing

This is a personal learning project, but suggestions welcome via:
- GitHub Issues (if hosted)
- Pull Requests for improvements
- Documentation enhancements

---

## 📄 License

This project is for educational purposes only. All tools and techniques should only be used in authorized testing environments.

---

## ✍️ Author

**Your Name**  
Cybersecurity Enthusiast | Penetration Testing Student  
[GitHub](https://github.com/yourusername) | [LinkedIn](https://linkedin.com/in/yourprofile)

---

## 🙏 Acknowledgments

- VirtualBox team for virtualization platform
- BloodHound team for AD enumeration framework
- Impacket developers for Python AD toolkit
- Offensive Security for Kali Linux
- Microsoft for Windows Server evaluation ISOs

---

**Last Updated:** February 2025  
**Lab Version:** 1.0  
**Status:** ✅ Operational