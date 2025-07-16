<#
File        : ad-computer-groups-ise.ps1
Copyright   : (c) 2025, Gergely Szabo
License     : MIT
#>

# Replace MyPC with the actual computer name.
$adComputer = "MyPC"
$computerGroups = (New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=Computer)(cn=$($adComputer)))")).FindOne().GetDirectoryEntry().memberOf

$groupNames = @()
foreach ($group in $computerGroups) {
    if ($group -match "^CN=([^,]+)") {
        $groupNames += $matches[1]
    }
}
$groupNames
