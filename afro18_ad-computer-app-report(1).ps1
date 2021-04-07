# Here's the script for getting the apps from the remote computer.
#
# In order for this to work, you must enable the WinRM service in the remote PC. You can do this via GPO. You can follow the steps here:
#
# https://support.auvik.com/hc/en-us/articles/204424994-How-to-enable-WinRM-with-domain-controller-Group-Policy-for-WMI-monitoring
#
# Also, the script only works if the computer is connected to the network and is reachable.
#
# I included a connectivity and winrm tests in the script to check if the computer can run the remote execution. If not, then it will skip to the next one.
#
# Lastly, please change the value of Line 1 to your desired destination folder. Also, please read the note I put there :)
#
# Attached text file is for the sample report. The name of the remote PC is win10-1 so the name of the text file is based on the computer name. It will create a text file for each computer and inside that the list of apps in that computer.
#
# Please let me know if you need further help or assistance on this script.
#
# Thank you very much! 
#
#

$txtPath = "C:\reports" # do not include a trailing \ at the end of the path. Correct: C:\reports | Incorrect: C:\reports\
$computers = Get-ADComputer -Filter *
if($computers.Count -gt 0) {
    $cCount = 0
    foreach($computer in $computers) {
        $cCount++
        $itemPercent = [math]::round((($cCount/$computers.Count) * 100), 0)
        Write-Progress -Activity:"Getting list of apps from $($computer.Name)" -Status:"Processing $cCount of $($computers.Count) computers ($itemPercent%)" -PercentComplete:$itemPercent

        $connection = Test-Connection -ComputerName $computer.Name -Count 3 -ErrorAction SilentlyContinue
        if($connection) {
            $winrm = Test-WSMan $server.ServerName -ErrorAction SilentlyContinue
            if($winrm) {
                try {
                    $apps = Invoke-Command -ComputerName $computer.Name -ScriptBlock {
                        Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object DisplayName -ne $null | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
                    } -ErrorAction Stop
                } catch {
                    Write-Host "There was a problem executing the command to $($computer.Name) -> $($_.Exception.Message)" -ForegroundColor Red
                }
                
                if($apps) {
                    $fileName = "$txtPath\$($computer.Name).txt"
                    $apps.DisplayName | Out-File -FilePath $fileName -Force -Encoding utf8
                }
            } else {
                Write-Host "WinRM service is not enabled at $($computer.Name). Skipping remote execution" -ForegroundColor Red
            }
        } else {
            Write-Host "Cannot reach $($computer.Name). Please make sure it's reachable from this server" -ForegroundColor Red
        }
    }
}