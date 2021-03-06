# Get AzureAD Guest Accounts and their Membership Info
Import-Module AzureAD

$GuestAccountExportFile = "C:\Temp\AzureDGuestAccountMemberships.csv "

$credential = Get-Credential -UserName "O365AdminUPNHere" -Message "Enter Admin Creds"


# Do Not Modify below

Connect-AzureAD -Credential $credential  # "prepare: usersname@domain.com"
$GuestAccounts = Get-AzureADUser -Filter "UserType eq 'Guest'" -All

$Results = @()
$GuestAccounts | % {
    $guest = $_

    $members = @()
    $members = Get-AzureADUserMembership -ObjectId  $($guest.ObjectId) 
    foreach($member in $members)
    {
    $guest | Add-Member -MemberType NoteProperty -Name MemberObjectId     -Value $member.ObjectId  -ea SilentlyContinue
    $guest | Add-Member -MemberType NoteProperty -Name MemberObjectType   -Value $member.ObjectType  -ea SilentlyContinue
    $guest | Add-Member -MemberType NoteProperty -Name MemberDisplayName  -Value $member.DisplayName  -ea SilentlyContinue
    $guest | Add-Member -MemberType NoteProperty -Name MemberMail         -Value $member.Mail  -ea SilentlyContinue
    $guest | Add-Member -MemberType NoteProperty -Name MemberMailEnabled  -Value $member.MailEnabled  -ea SilentlyContinue
    $guest | Add-Member -MemberType NoteProperty -Name MemberSecurityEnabled  -Value $member.SecurityEnabled   -ea SilentlyContinue
    }
    $Results += $guest
}

$Results | select AccountEnabled, UserPrincipalName, UserType, ObjectType, ObjectId, Mail, UserState, MemberObjectId, MemberObjectType, MemberDisplayName, MemberMail, MemberMailEnabled, MemberSecurityEnabled | Export-Csv $GuestAccountExportFile -nti

