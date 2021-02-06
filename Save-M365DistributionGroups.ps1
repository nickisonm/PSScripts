﻿# Script to get all the Distribution Lists in M365 Tenant

$date = Get-date -Format "dd_MMM_yyyy_hhmm"
$ExportCsv_M365DistributionLists = "c:\temp\M365DistributionLists_$($date).csv"


# M365 Admin Credential
$LiveCred = Get-Credential -Message "Enter M365 Admin Credentials"


  $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
  Import-PSSession $Session -CommandName Get-DistributionGroup,Get-DistributionGroupMember -FormatTypeName * -AllowClobber | Out-Null

# Get DLs in M365 Tenant and export to csv
Get-DistributionGroup -ResultSize Unlimited | Export-Csv $ExportCsv_M365DistributionLists -nti 

