# Get O365 Users with PowerBI License

# Import Module
Import-Module MSOnline


# Connect to Microsoft Online Services

Connect-MsolService

# Get all the Users where the users are given Yammer licenses
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -like "*PowerBI*"} | `
Select-Object UserPrincipalName, DisplayName | `
Export-Csv "C:\O365UsersWith_POWERBI_License.csv"  -NoTypeInformation -Encoding UTF8
