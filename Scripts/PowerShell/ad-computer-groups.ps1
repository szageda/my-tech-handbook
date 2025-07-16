<#
File        : ad-computer-groups.ps1
Copyright   : (c) 2025, Gergely Szabo
License     : MIT
#>

<#
.DESCRIPTION
    This script retrieves the Active Directory groups for a specified computer.
    If no computer name is provided, it defaults to the current computer the
    script is run on. The script uses the DirectoryServices namespace to query
    Active Directory and extract the group names from the computer's
    membership.
.NOTES
    This script requires the Active Directory module to be available in the
    PowerShell environment. Also, the script must be run on the same domain
    as the computer whose groups are being queried.
.PARAMETER computer
    The computer for which to retrieve the Active Directory groups. If not
    specified, it defaults to the current computer.
.PARAMETER computerGroups
    The groups that the specified computer belongs to, retrieved from Active
    Directory. This is an array of distinguished names (DNs) of the groups.
.PARAMETER groupNames
    An array that will hold the extracted group names (CN=GroupName) from the
    distinguished names of the groups.
.EXAMPLE
    .\ad-computer-groups-ise.ps1 MyPC   (retrieves groups for computer MyPC)
    .\ad-computer-groups-ise.ps1        (retrieves groups for the current
                                        computer)
#>
param (
    [string]$computer
)

if (-not $computer) {
    $computer = $env:COMPUTERNAME
}

$computerGroups = (New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=Computer)(cn=$($computer)))")).FindOne().GetDirectoryEntry().memberOf

$groupNames = @()
foreach ($group in $computerGroups) {
    if ($group -match "^CN=([^,]+)") {
        $groupNames += $matches[1]
    }
}
$groupNames
