######################################################################################
############################### SHOW MAILBOX TYPE ####################################
######################################################################################
##															                        ##
## Date : 23/02/2021                                                                ##
## Creator : Andy LETELLIER                                                         ##
## Version 1.0                                                                      ##
##                                                                                  ##
######################################################################################
## Functions :                                                                      ##
##                                                                                  ##
##  O365 / Exchange Online connection                                               ##
##                                                                                  ##
######################################################################################
## CHANGE LOG : [User][Date][Version] - Infos  #######################################
######################################################################################
##                                                                                  ##
## [ANDY][23/02/2021][1.0] - Script creation          	                            ##
##                                                                                  ##
##                                                                                  ##
######################################################################################


# Exchange online connection

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking -allowclobber

# Get mailbox Requst

$Result = Get-Mailbox -ResultSize unlimited | select displayname, RecipientTypeDetails, PrimarySmtpAddress | ft
 
# 1 Show the result 
$Result

# 2 CSV export file
# $Result | Export-Csv -Path "c:\Temp\O365ExchangeOnlineList.csv"

Remove-PSSession $Session

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');