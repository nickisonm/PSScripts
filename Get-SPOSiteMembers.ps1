# Script SharePoint Online - Get Site, Admins and Members Info

try
{
    Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
    Connect-SPOService -Url "https://site.admin.sharepoint.com" # -credential MERTool@tpicap365.onmicrosoft.com
    write-host "Connected to Sharepoint Online" -ForegroundColor Green
}
catch 
{
    Write-Host "Error:  $($Error[0].Exception.Message)" -ForegroundColor Yellow
    Read-Host "Please fix and try again. Press any key to exit"
    exit
}


$SPSites = Get-SPOSite -Limit All


# Get Site Memberhsips and save to file
$SiteMembershipFile =  "C:\Temp\SharepointOnlineSiteMembers.csv"
$SPSiteData = @()

$SPSites | % { 

       $SiteURL = $_.Url
  
       # Get Site Internal User acess membership
        $SPSiteUsers =  Get-SPOUser -Site $SiteURL -ea SilentlyContinue

        foreach($SiteUser  in $SPSiteUsers)
        {
            $data = '' | select SiteURL, UserType, UserDisplayName, UserLoginName, SiteAdministrator
            $data.UserType = $SiteUser.UserType
            $data.UserDisplayName = $SiteUser.DisplayName
            $data.SiteURL = $SiteURL
            $data.UserLoginName = $SiteUser.LoginName
            $data.SiteAdministrator = $SiteUser.IsSiteAdmin

            $SPSiteData += $data
        }
    
        # Get Site Guest User acess membership

        $SPSiteExternalUsers =  Get-SPOExternalUser -SiteUrl $SiteURL -ea SilentlyContinue

        foreach($SiteUser  in $SPSiteExternalUsers)
        {
            $data = '' | select SiteURL, UserType, UserDisplayName, UserLoginName, SiteAdministrator

            $data.UserType = "Guest"
            $data.UserDisplayName = $SiteUser.DisplayName
            $data.SiteURL = $SiteURL
            $data.UserLoginName = $SiteUser.AcceptedAs
            $data.SiteAdministrator = $SiteUser.IsSiteAdmin
            $SPSiteData += $data
        }

    }

 # Save to File
 $SPSiteData | export-csv $SiteMembershipFile -nti

