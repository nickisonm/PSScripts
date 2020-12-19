
# Get User Info
Write-Host "Getting User Information"

Import-Module ActiveDirectory

$OutputFolder = "C:\ADInfo"

if(!(Test-Path $OutputFolder))
{
    md $OutputFolder
}

try
{
    Get-ADUser -filter * -properties scriptpath, homedrive, homedirectory, passwordlastset  | select SamAccountName, givenname, Surname, Name, scriptpath, homedrive, homedirectory, passwordlastset | Export-Csv "$OutputFolder\ADUserInformation.csv" -nti
    Write-Host "Success: AD User Information is saved to $OutputFolder\ADUserInformation.csv"
}
catch { Write-Host "Failed: Getting AD User Information. Error: $($_.Exception.Message)" }
