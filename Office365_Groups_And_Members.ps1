Get-MsolGroupMember username | select name


Get-MsolGroupMember -All

$Object_Names = Write-host "What are the object ids?: "
$Object_Names | ForEach-Object {
 $GName = Get-MsolGroup -ObjectId $Object_Name | select DisplayName
 write-output "GROUP NAME: " $GName "  "
 (Get-MsolGroupMember -GroupObjectId $Object_Name).DisplayName
 write-output "----------------------------   "
 } | Out-File "C:\Group_Memebers.txt"
