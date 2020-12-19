# Script to Create New DHCP Scope

$ComputerName = read-host "MyDHCPServer: "
$ScopeName = read-host "Sample Scope Name: "
$StartIPAddress = read-host "Starting IP Address of Scope (x.x.x.x): "
$EndRange = read-host "Ending IP Address of Scope (x.x.x.x): "
$SubnetMask = read-host "Subnet Mask of Scope (x.x.x.x): "

$Description = 'Enter Description Here'

try 
{ 

Import-Module DHCPServer 

Add-DhcpServerv4Scope -name $ScopeName -StartRange $StartIPAddress -EndRange $EndRange -SubnetMask $SubnetMask -Description $Description -State InActive -LeaseDuration 8.00:00:00

sleep -Seconds 5

Get-DhcpServerv4Scope -ComputerName $ComputerName -name $ScopeName  | % { 
    $Scope = $_.ScopeId;
	
    Write-Host -ForegroundColor Yellow "Working on $Scope" 
    
    Set-DhcpServerv4DnsSetting -ComputerName $ComputerName -ScopeId $Scope -DynamicUpdates "OnClientRequest" -NameProtection $false  -DisableDnsPtrRRUpdates $True

	
    # A. Option Name = "003 Router", Vendor = "Standard", Value = "10.0.0.1", Policy Name = "None"
    Set-DhcpServerv4OptionValue -ComputerName $ComputerName -ScopeId $Scope -OptionId 3 -Value "10.0.0.1"  -PolicyName "None" -Vendorclass "Standard"

    # B. Option Name = "006 DNS Servers", Vendor = "Standard", Value = "10.0.0.5, 10.0.0.6", Policy Name = "None"
	Set-DhcpServerv4OptionValue -ComputerName $ComputerName -ScopeId $Scope -OptionId 6 -Value "10.0.0.5, 10.0.0.6" -PolicyName "None" -Vendorclass "Standard"
	
    # C. Option Name = "015 DNS Domain Name", Vendor = "Standard", Value = "domain.ad.justanexample.lie", Policy Name = "None"
    Set-DhcpServerv4OptionValue -ComputerName $ComputerName -ScopeId $Scope -OptionId 15 -Value "domain.ad.justanexample.lie" -PolicyName "None" -Vendorclass "Standard"
	
    # D. Option Name = "252 Proxy", Vendor = "Standard", Value = "https://ProxySite.JustAnExample.lie/firewall", Policy Name = "None"
    Set-DhcpServerv4OptionValue -ComputerName $ComputerName -ScopeId $Scope -OptionId 252 -Value "https://ProxySite.JustAnExample.lie/firewall" -PolicyName "None" -Vendorclass "Standard"

}

}
catch   { Write-Host "Error:  $($_.Exception.Message) " }
