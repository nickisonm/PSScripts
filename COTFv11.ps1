###########################################################
#    Name: Clear-Out The Files (COTF.ps1)                 #
#    Ver : 1.1                                            #
#    Created By: Marty Nickison                           #
#    Date: 06/05/2024                                     #
#                                                         #
#                                                         #
#    This script will do three primary things:            #
#    (for the specified directory on a Windows Machine)   # 
#                                                         #
#    1. Display the number of files in the directory      #
#    2. Output the total space used by files (see #1)     #
#    3. After hitting Enter, will delete all the files    #
#       in the specified directory                        #
###########################################################

cls

$timestamp = Get-Date -Format "yyyy_MM_dd_HH_ss"

# Get the Hostname of the computer
$hostname = $env:COMPUTERNAME

# Specify the location of log files
if (-not (Test-Path -Path "C:\Support")){ 
  New-Item -ItemType Directory -Path "C:\Support"
  }

# Define the log path file
$logFilePath = "C:\Support\COTF_+$hostname+$timestamp.log"

# Specify the directory path here
$directoryPath = "C:\Test_Folder2024"

# Get all the files in the directory
$files = Get-ChildItem -Path $directoryPath -File -Recurse

# Calculate the number of files
$numberOfFiles = $files.Count

# Calculate the total space used by the files
$totalSpaceUsed = "{0:N2}" -f (($files | Measure-Object -Property Length -Sum).Sum / 1GB)

# Display the results and add them to the log file
$Blankline1 = "......................................................................."                                                   
$Message1 = "This Data is Accurate as of $timestamp"
$Message2 = "Number of files in the directory TO BE DELETED: $numberOfFiles"
$Message3 ="Total space used by the files TO BE DELETED: $totalSpaceUsed GB"
Write-Host $Blankline1
Out-File -FilePath $logFilePath -InputObject $Blankline1 -Encoding ASCII -Append
Write-Host $Message1
Out-File -FilePath $logFilePath -InputObject $Message1 -Encoding ASCII -Append
Write-Host $Message2
Out-File -FilePath $logFilePath -InputObject $Message2 -Encoding ASCII -Append
Write-Host $Message3
Out-File -FilePath $logFilePath -InputObject $Message3 -Encoding ASCII -Append
Write-Host "                                                        "
Write-Host "                                                        "
Write-Host "Hit Enter to proceed deleting all files from: " $directoryPath

Pause

# Delete all files in the directory
Remove-Item $directoryPath\* -Force
$Message4 = "All files from $directoryPath have been deleted"
Write-Host $Message4
Out-File -FilePath $logFilePath -InputObject $Message4 -Encoding ASCII -Append
