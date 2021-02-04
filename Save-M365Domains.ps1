# Script to get the M365 Domains 


# M365 Admin Credential
$LiveCred = Get-Credential -Message "Enter M365 Admin Credentials"

# Import MSOnline Module
try 
{
    Import-Module msonline
    Write-Host "Imported MSOnline Module successfully." -ForegroundColor Green
}
catch
{
    Write-Host "Install MSOnline Module and try again." -ForegroundColor Yellow
}


try 
{
    Connect-MsolService -Credential $LiveCred
    Write-Host "Connected to M365 successfully." -ForegroundColor Green
}
catch
{
    Write-Host "Failed to connect to M365. Error : $($Error[0].Exception.Message)" -ForegroundColor Yellow
}


# Get the list of M365 Domains and save to File
Get-MsolDomain | Export-CSV c:\temp\o365domains.csv -nti

