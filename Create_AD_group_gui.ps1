Function Create_Group {
		#New-ADGroup -Name "RODC Admins" -SamAccountName RODCAdmins -GroupCategory Security -GroupScope Global -DisplayName "RODC Administrators" -Path "CN=Users,DC=Fabrikam,DC=Com" -Description "Members of this group are RODC Administrators"
		#New-ADGroup -Server localhost:60000 -Path "OU=AccountDeptOU,DC=AppNC" -Name "AccountLeads" -GroupScope DomainLocal -GroupCategory Distribution
}
Add-Type -AssemblyName System.Windows.Forms
# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Create Group in Acive Directory"
$form.Size = New-Object System.Drawing.Size(500, 520)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true



# Create a text box
$ADtextBox = New-Object System.Windows.Forms.TextBox
$ADtextBox.Location = New-Object System.Drawing.Point(40, 130)
$ADtextBox.Size = New-Object System.Drawing.Size(400, 150)
$ADtextBox.Multiline = $true
$ADtextBox.TextAlign = "Left"
$ADtextBox.ScrollBars = 'Both'
$ADtextBox.Font = New-Object System.Drawing.Font('Consolas', 10)

#$TabPage2.Controls.Add($ADtextBox)	
$form.Controls.Add($ADtextBox)
	

#remove Button
$gName = New-Object System.Windows.Forms.TextBox
$gName.Location = New-Object System.Drawing.Point(40, 40)
$gName.Size = New-Object System.Drawing.Size(200, 20)

$form.Controls.Add($gName)

$DomainSelectLabel= New-Object System.Windows.Forms.Label
$DomainSelectLabel.text = "Type Group Name:"
$DomainSelectLabel.Location = New-Object System.Drawing.Point(40,20)
$DomainSelectLabel.AutoSize = $true
#$TabPage2.Controls.Add($DomainSelectLabel)
$form.Controls.Add($DomainSelectLabel)

$DomainSelect = New-Object System.Windows.Forms.ComboBox
$DomainSelect.Width = 200
$DomainSelect.Location = New-Object System.Drawing.Point(40, 90)
[void] $DomainSelect.Items.Add("Dom1")
[void] $DomainSelect.Items.Add("Dom2")
[void] $DomainSelect.Items.Add("Dom3")

$DomainSelect.Add_SelectedIndexChanged({
    # for demo, just write to console
    $ADtextBox.AppendText("searching in '$($this.SelectedItem)' domain`r`n")
    # inside here, you can refer to the $DomainSelect as $this
    switch ($this.SelectedItem) {
        "dom1" {$domain="domain1"}
        "dom2" {$domain="domain2"}
        "dom3" {$domain="domain3"}
	}
	Start-Sleep -Seconds 1
	$ADtextBox.AppendText("domain is $Domain")
	
})



$ADPath= New-Object System.Windows.Forms.Label
$ADPath.text = "AD Path:"
$ADPath.Location = New-Object System.Drawing.Point(280, 330)
$ADPath.AutoSize = $true
#$TabPage2.Controls.Add($ADPath)
$form.Controls.Add($ADPath)




$objComboBox = New-Object System.Windows.Forms.ComboBox
$objComboBox.Width = 100
$objComboBox.Location = New-Object System.Drawing.Point(280, 350)
[void] $objCombobox.Items.Add("Service Account")
[void] $objCombobox.Items.Add("Resource Account")
[void] $objCombobox.Items.Add("Office365")
[void] $objCombobox.Items.Add("MyApps")
[void] $objCombobox.Items.Add("Group")

$objCombobox.Add_SelectedIndexChanged({
    # for demo, just write to console
	$domain =$DomainSelect.text
	$groupname = $gName.Text
    # inside here, you can refer to the $objCombobox as $this
    switch ($this.SelectedItem) {
        "Service Account" {$Path= "CN=$groupname,OU=ServiceAccounts,OU=Common,DC=$Domain,DC=Fabrikam,DC=Com"}
        "Resource Account" {$Path= "CN=$groupname,OU=ResourceAccounts,OU=Common,DC=$Domain,DC=Fabrikam,DC=Com"}
        "Office365" {$Path= "CN=$groupname,OU=Office365,OU=Groups,OU=Common,DC=$Domain,DC=Fabrikam,DC=Com"}
		"MyApps" {$Path= "CN=$groupname,OU=MyApps,OU=Groups,OU=Common,DC=$Domain,DC=Fabrikam,DC=Com"}
		"File" {$Path= "CN=$groupname,OU=File,OU=Groups,OU=Common,DC=$Domain,DC=Fabrikam,DC=Com"}
        
    }# =objCombobox.text
	Start-Sleep -Seconds 1
	$ADtextBox.AppendText("Path is $Path")
    $Global:Destination = $Path
})

#$TabPage2.Controls.Add($objComboBox)
$form.Controls.Add($objComboBox)


##########################################################

$groupTypeLabel= New-Object System.Windows.Forms.Label
$groupTypeLabel.text = "Group Type:"
$groupTypeLabel.Location = New-Object System.Drawing.Point(40,330)
$groupTypeLabel.AutoSize = $true
#$TabPage2.Controls.Add($groupTypeLabel)
$form.Controls.Add($groupTypeLabel)
	
#create Button

$grouptypeBox = New-Object System.Windows.Forms.ComboBox
$grouptypeBox.Width = 100
$grouptypeBox.Location = New-Object System.Drawing.Point(40, 350)
[void] $grouptypebox.Items.Add("Security")
[void] $grouptypebox.Items.Add("Distribution")

$grouptypebox.Add_SelectedIndexChanged({
    # for demo, just write to console
    $ADtextBox.AppendText("Group type '$($this.SelectedItem)'`r`n")
    # inside here, you can refer to the $objCombobox as $this
    switch ($this.SelectedItem) {
        "Security" {"Security"}
        "Distribution" {"Distribution"}
        
        
    }
})

$form.Controls.Add($grouptypebox)

$GroupScopeLabel= New-Object System.Windows.Forms.Label
$GroupScopeLabel.text = "Group Scope:"
$GroupScopeLabel.Location = New-Object System.Drawing.Point(160,330)
$GroupScopeLabel.AutoSize = $true
#$TabPage2.Controls.Add($GroupScopeLabel)
$form.Controls.Add($GroupScopeLabel)



$GroupScopeBox = New-Object System.Windows.Forms.ComboBox
$GroupScopeBox.Width = 100
$GroupScopeBox.Location = New-Object System.Drawing.Point(160, 350)
[void] $GroupScopebox.Items.Add("DomainLocal")
[void] $GroupScopebox.Items.Add("Global")
[void] $GroupScopebox.Items.Add("Universal")

$GroupScopebox.Add_SelectedIndexChanged({
    # for demo, just write to console
    $ADtextBox.AppendText("searching for '$($this.SelectedItem)'`r`n")
    # inside here, you can refer to the $objCombobox as $this
    switch ($this.SelectedItem) {
        "DomainLocal" {"DomainLocal"}
        "Global" {"Global"}
        "Universal" {"Universal"}
        
    }
})
$form.Controls.Add($GroupScopebox)

$DomainSelectLabel= New-Object System.Windows.Forms.Label
$DomainSelectLabel.text = "Domain"
$DomainSelectLabel.Location = New-Object System.Drawing.Point(40,70)
$DomainSelectLabel.AutoSize = $true
#$TabPage2.Controls.Add($DomainSelectLabel)
$form.Controls.Add($DomainSelectLabel)
	


$DomainSelect = New-Object System.Windows.Forms.ComboBox
$DomainSelect.Width = 100
$DomainSelect.Location = New-Object System.Drawing.Point(40, 90)
[void] $DomainSelect.Items.Add("Dom1")
[void] $DomainSelect.Items.Add("Dom2")
[void] $DomainSelect.Items.Add("Dom3")

$DomainSelect.Add_SelectedIndexChanged({
    # for demo, just write to console
    $ADtextBox.AppendText("searching in '$($this.SelectedItem)' domain`r`n")
    # inside here, you can refer to the $DomainSelect as $this
    switch ($this.SelectedItem) {
        "Dom1" {$domain="domain1"}
        "Dom2" {$domain="domain2"}
        "Dom3" {$domain="domain3"}
	}
	Start-Sleep -Seconds 1
	$ADtextBox.AppendText("domain is $domain")
	$Global:Domains = $domain	
})
#$TabPage2.Controls.Add($DomainSelect)
$form.Controls.Add($DomainSelect)


############################################

$descrLabel= New-Object System.Windows.Forms.Label
$descrLabel.text = "Description:"
$descrLabel.Location = New-Object System.Drawing.Point(40,400)
$descrLabel.AutoSize = $true
#$TabPage2.Controls.Add($descrLabel)
$form.Controls.Add($descrLabel)	
	
#disable Button
$descrBox = New-Object System.Windows.Forms.TextBox
$descrBox.Location = New-Object System.Drawing.Point(40, 420)
$descrBox.Size = New-Object System.Drawing.Size(370, 30)

$form.Controls.Add($descrBox)




##################################################################################
#export to csv
$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Location = New-Object System.Drawing.Point(40, 290)
$exportButton.Size = New-Object System.Drawing.Size(100, 20)
$exportButton.Text = "Export"
$exportButton.Add_Click({})
#$TabPage2.Controls.Add($exportButton)
$form.Controls.Add($exportButton)


#open Button
$openButton = New-Object System.Windows.Forms.Button
$openButton.Location = New-Object System.Drawing.Point(200, 290)
$openButton.Size = New-Object System.Drawing.Size(100, 20)
$openButton.Text = "Import"
$openButton.Add_Click({	
	$n = [System.Windows.Forms.MessageBox]::Show("Confirming that this tool does not modify scripts. Variables must be modified outside of this tool. Are you sure?", "Confirm", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    	if ($n -eq "Yes") {
			#Ignore confirm dialogs with -Confirm:$false
        	functionhere -Confirm:$false
		}
})
#$TabPage2.Controls.Add($openButton)
$form.Controls.Add($openButton)

$GCtextbutton = New-Object System.Windows.Forms.Button
$GCtextbutton.Location = New-Object System.Drawing.Point(360, 290)
$GCtextbutton.Size = New-Object System.Drawing.Size(80, 20)
$GCtextbutton.Text = "Clear Result"
$GCtextbutton.Add_Click({
    
	$ADtextBox.text="" 
    
})
$form.Controls.Add($GCtextbutton)


#Get Button	
$getButton = New-Object System.Windows.Forms.Button
$getButton.Location = New-Object System.Drawing.Point(300,90)
$getButton.Size = New-Object System.Drawing.Size(110, 20)
$getButton.Text = "Create Group"
$getButton.Add_Click({
	$name = $gName.Text
	$GroupScope = $GroupScopebox.text
	$grouptype = $grouptypebox.text
	$descr = $descrBox.text
    if ($DomainSelect.text -eq "") {
		
		$ADtextBox.AppendText("Select a domain")
	} else {
		
		$n = [System.Windows.Forms.MessageBox]::Show("Confirm creating New-ADGroup -Server $Global:Domains -Path $Global:Destination -Name $name -GroupScope $GroupScope -GroupCategory $grouptype -Description $descr. Are you sure?", "Confirm", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    	if ($n -eq "Yes") {
			$ADtextBox.AppendText("New-ADGroup -Server $Global:Domains -Path $Global:Destination -Name $name -GroupScope $GroupScope -GroupCategory $grouptype -Description $descr")
		}
	}
})

#$TabPage2.Controls.Add($getButton)
$form.Controls.Add($getButton)

#$TabPage2.    
$form.Add_KeyDown({
if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
            
	Get-getitem
	}	
})


$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
