Function Get-Userlist {
    $groupName = Read-Host "type Group Name"
	#Specify domain
	$Domain = "comp.company.cub"
	Write-Host "Domain is $Domain"
	$Userslist = Get-ADGroupMember -Identity $groupName -Server $Domain -ErrorAction Stop
    $Users = $Userslist.SamAccountName 
    $Export = $groupName + "_Userlist.csv"
	$GlobalCatalog = "dc01.company.cub:3268"

    # Create an empty array to hold the user data
    $UserData = @()

    foreach ($user in $Users) {
        try {
            # Retrieve user details
            $userDetails = Get-ADUser -Server $GlobalCatalog -Filter {SamAccountName -eq $user} -Properties * 
            # Create a custom object with the desired properties
            $userObject = [pscustomobject]@{
				EmployeeID         = $userDetails.employeeID
                Name               = $userDetails.Name
            }
            # Add the object to the array
            $UserData += $userObject
			
        } catch {
            Write-Warning "Failed to retrieve user details for $($user): $_"
        }
    }

    # Export all collected data to CSV
    $UserData | Export-Csv $Export
	Write-Host "$($Export) created"
}


# Call the function
Get-Userlist