Function find_Group {
	# Get the list of domains in the forest
	$Domains = (Get-ADForest).Domains

	# Prompt the user to enter the group name
	$groupName = Read-Host "Type Group Name"

	# Loop through each domain and search for the group
	foreach ($domain in $Domains) {
		Write-Host "Searching in domain: $domain"
		try {
			$groups = Get-ADGroup -Server $domain -Filter {sAMAccountName -like $groupName } -ErrorAction Stop
			#$groups = Get-ADGroup -Server $domain -Identity $groupName -ErrorAction Stop
			if ($groups.Count -gt 0) {
				Write-Host "Matched groups in domain $domain"
				$groups | ForEach-Object { Write-Host "`t$($_.Name)" }
			}
			else {
				Write-Host "`tNo groups matched in domain $domain." 
			}
		}
		catch {
			Write-Host "Error searching in domain: $domain" 
			Write-Host $_.Exception.Message
		}
	} 
}

find_Group