<#
File        : ad-user-groups.ps1
Copyright   : (c) 2025, Gergely Szabo
License     : MIT
#>

<#
.DESCRIPTION
    This script retrieves the Active Directory groups for a specified user.
    If no username is provided, it defaults to the currently logged-in user.
    The script uses the DirectoryServices namespace to query Active Directory
    and extract the group names from the user's membership.
.NOTES
    This script requires the Active Directory module to be available in the
    PowerShell environment. Also, the script must be run on the same domain
    as the user whose groups are being queried.
.PARAMETER username
    The username for which to retrieve the Active Directory groups. If not
    specified, it defaults to the current user's username.
.PARAMETER userGroups
    The groups that the specified user belongs to, retrieved from Active
    Directory. This is an array of distinguished names (DNs) of the groups.
.PARAMETER groupNames
    An array that will hold the extracted group names (CN=GroupName) from the
    distinguished names of the groups.
.EXAMPLE
    .\ad-user-groups-ise.ps1 JDoe   (retrieves groups for user JDoe)
    .\ad-user-groups-ise.ps1        (retrieves groups for the current user)
#>
param (
    [string]$username
)

if (-not $username) {
    $username = $env:USERNAME
}

$userGroups = (New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=$($username)))")).FindOne().GetDirectoryEntry().memberOf

$groupNames = @()
foreach ($group in $userGroups) {
    if ($group -match "^CN=([^,]+)") {
        $groupNames += $matches[1]
    }
}
$groupNames
