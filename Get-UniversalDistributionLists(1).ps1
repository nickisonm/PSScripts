# Script to Get the Universal Distribution Groups and their Proxy Addresses

 

$OutFile = "C:\temp\UniversalDistributionGroupsInfo.csv"

$OU = "OU=Distribution Lists,OU=Groups,OU=EUC,DC=us,DC=domain,DC=com"

# Import Module
Import-Module activedirectory
 
# Get the Distribution Groups and filter by Universal Distribution Groups only
$DistributionGroups = Get-ADGroup  -Filter * -SearchBase $OU -Properties proxyAddresses | ?  { ($_.Groupscope -eq "Universal")  -and ($_.GroupCategory -eq "Distribution") }

# Save the Distribution Groups to file
$DistributionGroups | select Name, GroupScope, GroupCategory, SamAccountName, @{l='ProxyAddresses';e={$_.ProxyAddresses -join ';'}} | export- $OutFile -nti
