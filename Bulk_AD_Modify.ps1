Function Bulk_addUsers {
	$Path= "CN=$groupname,OU=Groups,OU=Common,DC=$Domain,DC=company,DC=cub"
	$domain="comp.company.cub"
	# Create an OpenFileDialog
	$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$openFileDialog.Filter = "All Files (*.*)|*.*"
	$openFileDialog.Title = "Select a File"
	
	# Show the dialog and get the result
	if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
		# Store the selected file path in a variable
		$filePath = $openFileDialog.FileName
		Write-Host "Selected file path: $filePath"
	} else {
		Write-Host "No file was selected."
	}

	Import-Csv "$filePath" | ForEach-Object {
	$employeeID = $_.employeeID
	Get-ADUser -Server "$domain" -Filter "employeeID -eq '$employeeID'" | % {
		
		add-ADGroupMember -Identity $($Path) -Server $($domain) -Members $_}
	}
}  

Bulk_addUsers
