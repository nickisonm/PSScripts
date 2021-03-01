# Script SharePoint Online - Get Site Size and Members Info

try
{
    Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
    Connect-SPOService -Url "https://tpicap365-admin.sharepoint.com" # -credential MERTool@tpicap365.onmicrosoft.com
    write-host "Connected to Sharepoint Online" -ForegroundColor Green
}
catch 
{
    Write-Host "Error:  $($Error[0].Exception.Message)" -ForegroundColor Yellow
    Read-Host "Please fix and try again. Press any key to exit"
    exit
}


# Get Sharepoint Site Sizes and save to file

$SiteSizeFile = "c:\temp\SharepointOnlineSiteSizes.csv"

$SPSites = Get-SPOSite -Limit All
$SPSites | select URL, @{l='SiteSize (MB)';e={"$($_.storageUsageCurrent)"}}  | export-csv $SiteSizeFile -nti


# Get Site Memberhsips and save to file
$SiteMembershipFile =  "C:\Temp\SharepointOnlineSiteMemberships.csv"
$SPSiteData = @()

$SPSites | % { 

       $SiteURL = $_.Url
  
       # Get Site Internal User acess membership
        $SPSiteUsers =  Get-SPOUser -Site $SiteURL -ea SilentlyContinue

        foreach($SiteUser  in $SPSiteUsers)
        {
            $data = '' | select SiteURL, UserType, UserDisplayName, UserLoginName    
            $data.UserType = $SiteUser.UserType
            $data.UserDispayName = $SiteUser.DisplayName
            $data.SiteURL = $SiteURL
            $data.UserLoginName = $SiteUser.LoginName

            $SPSiteData += $data
        }
    
        # Get Site Guest User acess membership

        $SPSiteExternalUsers =  Get-SPOExternalUser -SiteUrl $SiteURL -ea SilentlyContinue

        foreach($SiteUser  in $SPSiteExternalUsers)
        {
            $data = '' | select SiteURL, UserType, UserDisplayName, UserLoginName    

            $data.UserType = "Guest"
            $data.UserDispayName = $SiteUser.DisplayName
            $data.SiteURL = $SiteURL
            $data.UserLoginName = $SiteUser.AcceptedAs

            $SPSiteData += $data
        }

    }

 # Save to File
 $SPSiteData | export-csv $SiteMembershipFile -nti
