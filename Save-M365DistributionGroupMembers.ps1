# Script to get all the Distribution Lists in M365 Tenant

$date = Get-date -Format "dd_MMM_yyyy_hhmm"
$ExportCsv_M365DistributionMembersFile = "c:\temp\M365DistributionMembers_$($date).csv"


# M365 Admin Credential
$LiveCred = Get-Credential -Message "Enter M365 Admin Credentials"


  $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
  Import-PSSession $Session -CommandName Get-DistributionGroup,Get-DistributionGroupMember -FormatTypeName * -AllowClobber | Out-Null


# Get DLs in M365 Tenant and members and export to csv
$Results = @()

$Groups = Get-DistributionGroup -ResultSize Unlimited

foreach($Group in $Groups)
{
    Get-DistributionGroupMember $($Group.Name) | ForEach-Object {
      

        $data = '' | select Group, GroupEmailAddress, GroupType, Member, MemberEmailAddress, MemberRecipientType
        $data.Group = $Group.Name
        $data.GroupEmailAddress = $Group.PrimarySmtpAddress
        $data.GroupType = $Group.GroupType

        $data.Member = $_.Name
        $data.MemberEmailAddress = $_.PrimarySMTPAddress
        $data.MemberRecipientType = $_.RecipientType

        $Results += $data

}

}
 
$Results | Export-CSV $ExportCsv_M365DistributionMembersFile -nti
