# The script will ask for the full domain (meditate.peace.healthylife.com; for example) and the name of the folder (Diamond Audio; for example). 
# Given the answers, the script will create an OU (example, Diamond Audio) with the following OU's as subfolders below Diamond Audio: 
# Contacts, Exchange Temporary Contacts, Local Security Groups, Service and Test Accounts, Standard Computer, Standard User, Universal Security Groups.

$FQDN = Read-Host "Enter the FQDN "
$FolderName = Read-Host "Enter the Folder Name "


Import-Module activedirectory

# Assemble the DN by replacing 
$DN = 'CN=' + $FQDN.Replace('.',',CN=')

# Create Main OU
New-ADOrganizationalUnit -Name $FolderName -Path $DN

$DN = "OU=$folderName," + $DN

'Contacts', 'Exchange Temporary Contacts', 'Local Security Groups', 'Service and Test Accounts', 'Standard Computer', 'Standard User', 'Universal Security Groups' | % {

    New-ADOrganizationalUnit -Name $_ -Path $DN
}
