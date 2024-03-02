## Team 3 script for configuring AD OUs

Import-Module ActiveDirectory
Import-Module GroupPolicy

## Create OUs for AD

$parentOU = "OU=COMP_Internal_Machines,DC=Allsafe,DC=com"
New-ADOrganizationalUnit -Name "COMP_Internal_Machines" -Path "DC=Allsafe,DC=com"
New-ADOrganizationalUnit -Name "COMP_Servers" -Path $parentOU
New-ADOrganizationalUnit -Name "COMP_Workstations" -Path $parentOU
New-ADOrganizationalUnit -Name "COMP_Groups" -Path "DC=Allsafe,DC=com"
$parentUserOU = "OU=COMP_Users,DC=Allsafe,DC=com"
New-ADOrganizationalUnit -Name "COMP_Users" -Path "DC=Allsafe,DC=com"
New-ADOrganizationalUnit -Name "COMP_RESTRICTED_Users" -Path $parentUserOU

## Disable and Move ASMAIL1 Computer

$computerName = "ASMAIL1"
$targetOU = "OU=COMP_Workstations,OU=COMP_Internal_Machines,DC=Allsafe,DC=com"
$computerDN = (Get-ADComputer $computerName).DistinguishedName
Disable-ADAccount -Identity $computerDN
Move-ADObject -Identity $computerDN -TargetPath $targetOU

## Create NTP Server GPO

New-GPO -Name "COMP_NTP_Server" -Comment "1.21 gigawatts!"
New-GPLink -Name "COMP_NTP_Server" -Target "OU=Domain Controllers,DC=Allsafe,DC=com"

## Create NTP Client GPO

New-GPO -Name "COMP_NTP_Client" -Comment "1.21 gigawatts!"
New-GPLink -Name "COMP_NTP_Client" -Target "OU=COMP_Internal_Machines,DC=Allsafe,DC=com"

## Create Restricted Workstations GPO

New-GPO -Name "COMP_Restricted_Admin_Rights" -Comment "Ah ah ah, you didn't say the magic word"
New-GPLink -Name "COMP_Restricted_Admin_Rights" -Target "OU=COMP_Workstations,OU=COMP_Internal_Machines,DC=Allsafe,DC=com"

## Create Domain Policy GPO

New-GPO -Name "COMP_Domain_Policy" -Comment "One ring to rule them all"
New-GPLink -Name "COMP_Domain_Policy" -Target "DC=Allsafe,DC=com"

## Create RESTRICTED User GPO

New-GPO -Name "COMP_RESTRICTED" -Comment "No, this is me in a nutshell!"
New-GPLink -Name "COMP_RESTRICTED" -Target "OU=COMP_RESTRICTED_Users,OU=COMP_Users,DC=Allsafe,DC=com"
