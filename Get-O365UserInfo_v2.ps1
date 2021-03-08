# Get O365 User Infor 

Import-Module MSOnline
Import-Module AzureAD


$Outfile  = "c:\temp\M365UserInfo.csv"

$credential = Get-Credential -UserName "Admin@domain.com" -Message "Enter O365 Admin Creds"

# connect to Azure Active Directory (AD) using the Azure Active Directory PowerShell for Graph module.
try 
{
    Connect-AzureAD -Credential $credential 
    Write-Host "Connected to AzureAD" -ForegroundColor Green
}
catch 
{
    Write-Host "Failed Connecting to AzureAD" -ForegroundColor Yellow
}

# Connect to Office 365
try
{
    Connect-MsolService -Credential $credential 
    Write-Host "Connected to Msol Service" -ForegroundColor Green
}
catch 
{
    Write-Host "Failed Connecting to MSOnline" -ForegroundColor Yellow
}


$O365Users = Get-AzureADUser -All $true

$AllUserInfo = $O365Users | select UserType, DisplayName, @{l='SignInName';e={$_.SignInNames}}, UserPrincipalName, @{l='PrimaryEmailAddress';e={($_.ProxyAddresses | ? { $_ -clike "SMTP:*"} ) -replace "SMTP:",''}}, `
 @{l='EmailAliases';e={$_.ProxyAddresses -join ','}}, @{l='Licenses';e={$license = get-msoluser $($_.UserPrincipalName); $license.Licenses.accountskuid -join ','}}

$AllUserInfo | export-csv $Outfile -nti
