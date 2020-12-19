######################################################################################################
#                       
#   Get-ADComputerUserInfo 
#   This script will gather server, client computer, and user object data for the entire domain
#   of the domain controller that you run this on and put it in two directories:
#
#    C:\ComputersInDomain
#    C:\UsersInDomain
#
######################################################################################################


Write-Host "Please Wait As Computer Information Is Collected"

md "C:\ComputersInDomain" -ea SilentlyContinue| Out-Null

$Computers = get-adcomputer -properties Name, LastLogonDate, ipv4Address, OperatingSystem | select Name, LastLogonUser, LastLogonDate, ipv4Address, OperatingSystem, WindowsUpdateCheckedOn


$Computers | % {

    $Computer = $_.Name
    Write-Host "Collecting Data for Computer: $Computer"

    if(Test-Connection -ComputerName $Computer -Count 1 -Quiet)
    {
        $RC = Get-WinEvent -Computer $Computer -FilterHashtable @{ Logname = ‘Security’; ID = 4672 } -MaxEvents 1 | Select @{ N = ‘User’; E = { $_.Properties[1].Value } }, TimeCreated

        $_.LastLogonUser = $RC.User
        $_.LastLogonDate = $RC.TimeCreated
        $_.WindowsUpdateCheckedOn = Invoke-Command -ComputerName $Computer -ScriptBlock { (New-Object -com "Microsoft.Update.AutoUpdate").Results.LastInstallationSuccessDate.tostring() }
    }
    else
    {
        $_.WindowsUpdateCheckedOn = "OFFLINE"
    }
}
$Computers | Export-Csv C:\ComputersInDomain\ComputersInDomain.csv -nti


# Get User Info
Write-Host "Please Wait As User Information Is Collected
md "C:\UsersInDomain" -ea SilentlyContinue| Out-Null
Get-ADUser -filter * -properties scriptpath, homedrive, homedirectory, passwordlastset  | select SamAccountName, Name, scriptpath, homedrive, homedirectory, passwordlastset | Export-Csv C:\UsersInDomain\UsersInDomain.csv -nti

Invoke-Item "c:\UsersInDomain"
