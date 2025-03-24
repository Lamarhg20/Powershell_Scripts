Import-Module ActiveDirectory
Import-Csv "users_results.csv" | ForEach-Object {
   $GlobalCatalog = "dc01.Company.cub:3268"
   $userPrincipalName = $_.userPrincipalName
   Get-ADUser -Server $GlobalCatalog -Filter "userPrincipalName -eq '$userPrincipalName'" |
   % { Add-ADGroupMember -Identity "CN= Engineering,OU=Groups,DC=comp,DC=company,DC=cub" -Server comp.company.cub -Members $_ }
   }
