#Version 2
for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i;



$ErrorActionPreference= 'silentlycontinue'

Write-Output *Excution Policy
Set-ExecutionPolicy unrestricted -Force
set-executionpolicy remotesigned -Force

##[disable UAC]
write-output *Disable UAC
New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

##[disable firewall]
write-output *disable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

##[Remote Desktop]
write-output *Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
write-output *Windows Update
##[Windows Update]
New-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -Value 1
write-output *Change Time Zone
##[Change Time Zone]
Set-TimeZone -Id "Egypt Standard Time"
write-output *Add Language Arabic
##[Add Language Arabic]
$LanguageList = Get-WinUserLanguagelist 
$LanguageList.Remove("ar-EG")
$LanguageList.Add("ar-EG")
Set-WinUserLanguageList $LanguageList -Force  -Confirm
#Setup User Language List
Set-WinUserLanguageList -Force ("en-US"), ("ar-EG")
Set-WinSystemLocale -SystemLocale  ("ar-EG")
Set-WinHomeLocation -GeoID 0x43
Get-WinSystemLocale
#Copy User Language List to Welcome screen and New user accounts
$DefaultUserHive = $env:SystemDrive + "\Users\Default\NTUSER.DAT"
reg load HKU\DefaultUserHive $DefaultUserHive
$MyProfileCurrentPath = "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Keyboard Layout\Preload"
$UserProfiles = Get-ChildItem "Microsoft.PowerShell.Core\Registry::HKEY_USERS"
$MyProfileCurrentPathProperty = (Get-Item $MyProfileCurrentPath).Property
$RegKeyArray = @()
Foreach ($UserProfile in $UserProfiles) {$RegKeyArray += 'Microsoft.PowerShell.Core\Registry::' `
+ $UserProfile.Name  + '\Keyboard Layout\Preload'} 
Foreach ($RegKey in $RegKeyArray) {$MyProfileCurrentPathProperty | ForEach-Object -Process `
{Copy-ItemProperty -Path $MyProfileCurrentPath -Destination $RegKey -Name $_}}
$MyProfileCurrentPath = "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Control Panel\International\User Profile"
$RegKeyArray = @()
Foreach ($UserProfile in $UserProfiles) {$RegKeyArray += 'Microsoft.PowerShell.Core\Registry::' + $UserProfile.Name `
+ '\Control Panel\International\User Profile'} 
Foreach ($RegKey in $RegKeyArray) {Copy-ItemProperty -Path $MyProfileCurrentPath -Destination $RegKey -Name Languages}
$UserProfile.Flush()
$UserProfile.Close()
$UserProfiles.Flush()

write-output *Change internet time
##[Change internet time]
w32tm /config /syncfromflags:manual /manualpeerlist:”10.1.1.100” /reliable:yes /update
write-output *Change Short and Long Date
##[Change Short and Long Date]
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sShortDate -Value dd/MM/yyyy
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sLongDate -Value dd/MM/yyyy
write-output *Disable IPv6
##[Disable IPv6]
Disable-NetAdapterBinding –InterfaceAlias Ethernet0 –ComponentID ms_tcpip6
Disable-NetAdapterBinding –InterfaceAlias Ethernet1 –ComponentID ms_tcpip6
write-output *Rename Adapter
##[rename Adapter]
Rename-NetAdapter -Name Ethernet0 -NewName "Main"
Rename-NetAdapter -Name Ethernet1 -NewName "Mirror"
write-output *Add computer Description
##[Add computer Description]
$comdescription= Read-Host "Enter Computer Decription"
$OSWMI=Get-WmiObject -class Win32_OperatingSystem 
$OSWMI.Description="comdescription"
$OSWMI.put()
write-output *Add Server Name
##[Add Server Name]
$newname = Read-Host -Prompt "input your server name"
Rename-computer –newname “$newname”  –force
#change Maximum Age
net accounts /maxpwage:unlimited
#Minimum length
net accounts /minpwlen:0
}
