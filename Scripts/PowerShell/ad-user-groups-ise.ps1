<#
File        : ad-user-groups-ise.ps1
Copyright   : (c) 2025, Gergely Szabo
License     : MIT
#>

# Replace JDoe with the actual username.
$adUser = "JDoe"
$userGroups = (New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=$($adUser)))")).FindOne().GetDirectoryEntry().memberOf

$groupNames = @()
foreach ($group in $userGroups) {
    if ($group -match "^CN=([^,]+)") {
        $groupNames += $matches[1]
    }
}
$groupNames
