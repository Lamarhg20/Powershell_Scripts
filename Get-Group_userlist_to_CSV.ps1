
# Clear old log files
$Limit = (Get-Date).AddDays(-90)
$LogFilePath = "c:\Exports"

# Delete files older than the $limit.
Get-ChildItem -Path $LogFilePath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $Limit } | Remove-Item -Force

#$date = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
$date = Get-Date -Format "MM-dd-yyyy"
$ExportFile = 'c:\Exports\' + $date + "_list.csv"

$domains = Get-ADForest | Select-Object -ExpandProperty Domains
$GroupName = '*'+'Examplegroupsname'
Write-Host $domains

$result = @()
foreach ($domain in $domains) {
        try {
            # Search for groups in the current domain
            $groups = Get-ADGroup -Filter { Name -like $GroupName } -Server $domain

            foreach ($group in $groups) {
                # Get members of the group
                $members = Get-ADGroupMember -Identity $group -Server $domain

                foreach ($member in $members) {
                    # Get the user details
                    $user = Get-ADUser -Identity $member -Server $domain -Properties enabled,userPrincipalName,employeeID,givenName,sn,extensionAttribute,mail,telephoneNumber,mobile,physicalDeliveryOfficeName,department,l | Select enabled,userPrincipalName,employeeID,givenName,sn,mail,telephoneNumber,@{N='mobilePhone';E={$_.mobile}},@{n="Office";e={$_.physicalDeliveryOfficeName}},@{N='REGION';E={$_.extensionAttribute}},@{N='city';E={$_.l}} | Where-Object {$_.Enabled -eq "TRUE"} | export-csv $ExportFile -Delimiter "," -Append -NoTypeInformation -Encoding UTF8
                    
                }
            }
        } catch {
            Write-Host "Error accessing domain $domain"
        }
}
return $result
