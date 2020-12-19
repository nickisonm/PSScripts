#####################################
#                                   #
#    File Server Copy Mirror        #  
#    11/24/2020                     #
#    By: Marty Nickison             #
#                                   #
#####################################

#REQUIRED INPUTS#
$Source = Read-Host -Prompt 'Please provide the full path to the source to be copied (ex. "C:\RootFolder\SourceFolder\")'
$Destination = Read-Host -Prompt 'Please provide the full path to the destination of the copy (ex. "D:\RootFolder\DestinationFolder\")'
$LogFileName = Read-Host -Prompt 'Please provide a name for the log file (ex."copy_log_today.log")'

#VERIFICATION#
Write-Host $Source ' is going to be mirror copied to ' $Destination

#THE SECRET SAUCE#
robocopy.exe $Source $Destination /LOG:$LogFileName /MIR /r:10 /w:10

$Source2 = $source -replace ‘["]’
$Destination2 = $Destination -replace ‘["]’
Invoke-Item $Source2, $Destination2