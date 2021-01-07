#######################################################################################
#                                                                                     #
#    RoboCopy From *.CSV                                                              #
#    NICKISONM                                                                        #
#    01/07/2021                                                                       #
#                                                                                     #
#    THIS SCRIPT WILL READ IN A *.CSV FILE FROM C:\ROBOCOPYDATA\COPYDETAILS.CSV       #
#    AND FOR EACH LINE IN THE FORMAT (SOURCE,DESTINATION,LOGFILEFULLFILENAME),        #
#    WILL COPY THE SOURCE OF EACH LINE TO THE DESTINATION OF EACH LINE; WITH A        # 
#    LOG BEING KEPT AT THE LOFGILEFULLNAME LOCATION.                                  #
#                                                                                     #
#                                                                                     #
#######################################################################################

# New-PSDrive -Name V -PSProvider FileSystem -Root \\(server)\(path)\(path)\ -Credential (username_domain)\(username)

# New-PSDrive -Name T -PSProvider FileSystem -Root \\(server)\(path)\(path) -Credential (username_domain)\(username)

net use t: \\(server)\(path)\(path) /user:(username_domain)\(username)


$items = import-csv c:\RoboCopyData\CopyDetails.csv

foreach($item in $items)
{
    try 
    {
        Write-Host "Copying $($items.source) -> $($items.destination) Log : $($items.LogFile)"
        robocopy $($items.source) $($items.destination) /S /XO /log+:"$($items.LogFile)"
        Write-Host "SUCCESS: Copied $($items.source) -> $($items.destination) Log : $($items.LogFile)" -ForegroundColor Green
    }
    catch { 
    
       Write-Host "ERROR: $($_.exception.Message)" -ForegroundColor Yellow
     }
}