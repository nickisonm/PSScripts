$exportPath = "C:\temp\computer-report.csv"
$computers = Get-ADComputer -Filter * -Properties OperatingSystem
[System.Collections.ArrayList]$compArr = @()
if($computers.Count -gt 0) {
    $cCount = 0
    foreach($computer in $computers) {
        $cCount++
        $itemPercent = [math]::round((($cCount/$computers.Count) * 100), 0)
        Write-Progress -Activity:"Getting info from $($computer.Name)" -Status:"Processing $cCount of $($computers.Count) computers ($itemPercent%)" -PercentComplete:$itemPercent
        
        $row = [pscustomobject][ordered]@{
            DN = $computer.DistinguishedName
            Name = $computer.Name
            OS = $computer.OperatingSystem
        }
        [void]$compArr.Add($row)
    }

    $compArr | Export-Csv -Path $exportPath -NoTypeInformation -Encoding UTF8 -Force
}