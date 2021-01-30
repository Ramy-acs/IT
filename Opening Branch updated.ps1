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
#$comdescription= Read-Host "Enter Computer Decription"
$OSWMI=Get-WmiObject -class Win32_OperatingSystem 
$OSWMI.Description="Ramy-Admin"
$OSWMI.put()
write-output *Add Server Name
##[Add Server Name]
#$newname = Read-Host -Prompt "input your server name"
Rename-computer –newname “Ramy-Admin”  –force
#change Maximum Age
net accounts /maxpwage:unlimited
#Minimum length
net accounts /minpwlen:0

#test Path
Write-Output *Test Path
$testpath
if( $testpath = true){
test-path "\\10.1.1.216\g$\System & Backup Department"
else
Net use "\\10.1.1.216\g$\System & Backup Department"
}


#create folders
#Write-Output *Create Folders on PC
#New-Item -Path "c:\" -Name "Script" -ItemType "directory"
#Write-Output *Create bat file Done
#New-Item -Path "c:\Script" -Name "Bat Files" -ItemType "directory"
#Write-Output *Create Crack Done
#New-Item -Path "c:\Script\" -Name "Crack" -ItemType "directory"
#Write-Output *Create Fujitu Fonts Done
#New-Item -Path "c:\Script\" -Name "Fujitu Fonts" -ItemType "directory"
#Write-Output *Create Veeam Done
#New-Item -Path "c:\Script\" -Name "Veeam" -ItemType "directory"
#Write-Output *Create Del Files Done
#New-Item -Path "c:\Script\" -Name "Del Files" -ItemType "directory"
#Write-Output *Create Kasper Done
#New-Item -Path "c:\Script\" -Name "Kasper" -ItemType "directory"
#download files from Network

$c = Get-Credential
#Get-CimInstance Win32_DiskDrive -ComputerName WFSRV  -Credential $c
Get-CimInstance Win32_BIOS -ComputerName WFSRV -Credential (Get-Credential -Credential fathalla\r.nada)

$path= "\\10.1.1.216\g$\System & Backup Department\Branch Opening Sources\Script\last update create Users"

[System.IO.Directory]::Exists($path)
#Test-Path $path
$localPath = "C:\Script"
if([System.IO.Directory]::Exists($localpath))
{
Write-Output "It is Aleardy exist"

return
}

else{

for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Id 1 -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i;

if ($path = [System.IO.Directory]::Exists($path)){$i++
echo D|xcopy /S /Q /Y /F "\\10.1.1.216\g$\System & Backup Department\System Scripts\SystemFiles\*." "C:\Script"

echo D|xcopy /S /Q /Y /F "\\10.0.29.90\F$\Upgrade Branches DB\SQL 2016\*" "D:\SQL 2016 "
continue; 
}

}
}



echo D|xcopy /S /Q /Y /F "F:\Upgrade Branches DB\SQL 2016\*" "D:\SQL 2016 "


#Run bat script

$ErrorActionPreference= 'silentlycontinue'

Write-Output * last update create Users
Start-Process -verb runas   "c:\Script\BatFiles\last update create Users.bat"
Write-Output * Enable hidden share
Start-Process -verb runas   "C:\Script\BatFiles\Enable hidden share.bat"

#Write-Output * ScriptToRun
#Start-Process -verb runas   "C:\Script\Del Files\ScriptToRun - Copy.bat"



#Write-Output * Acronis
#Start-Process -verb runas   "C:\Script\Kasper\AT Batch@ domain.bat"

#########################################################################################################                  
                                
                                   #Install Fonts#


Write-Output *Install Fonts
$FONTS = 0x14
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)

$localPath = "C:\Script\Fonts\"
$fontPath = "$env:windir\Fonts\"


    $fontSource = Get-ChildItem $localPath
    foreach($font in $fontSource) {
        if (!(Test-Path $fontPath\$font))
        {
            if(!($font.Extension -eq ".PFB")){    # Only PFM file needs to be copied (Type-1 Font)
                $objFolder.CopyHere($font.FullName,0x14)
            }
        }
    }
#########################################################################################################
#Audit Plicies
$additpol = auditpol.exe /get /category:* 
if(auditpol.exe){$additpol}



#########################################################################################################

#Enable success and failure

#########################################################################################################




auditpol /set /category:”object access” /success:enable /failure:enable

Write-Output ” Object Access – Policy Updated”


auditpol /set /category:”account logon” /success:enable /failure:enable

Write-Output ” Account Logon – Policy Updated”


auditpol /set /category:”policy change” /success:enable /failure:enable

Write-Output ” Policy Change – Policy Updated”


auditpol /set /category:”account management” /success:enable /failure:enable

Write-Output ” Account Management – Policy Updated”


auditpol /set /category:”ds access” /success:enable /failure:enable

Write-Output ” DS Access – Policy Updated”


auditpol /set /category:”privilege use” /success:enable /failure:enable

Write-Output ” Privilege Use – Policy Updated”


auditpol /set /category:”system” /success:enable /failure:enable

Write-Output ” System Policy Updated”


auditpol /set /category:”logon/logoff” /success:enable /failure:enable

Write-Output ” Logon/Logoff Policy Updated”

auditpol /set /category:”service access” /success:enable /failure:enable

Write-Output ” service access Policy Updated”


auditpol /set /category:"detailed Tracking" /success:enable /failure:enable

Write-Output ”Detaile Tracking Policy Updated”

auditpol.exe /get /category:* 
##############################################################################################################

##############################################################################################################

#Run Crack

###############################################################################################################

Write-Output *Crack
$mountResult = Mount-DiskImage "C:\Script\Crack\crack 2012.iso" -PassThru
$mountResult | Get-Volume
Copy-Item -PassThru "%\KMSAuto Net 2015 v1.3.5 Portable%" -Destination "C:\Users\Administrator\Downloads" -Recurse -Force
Start-Process -verb runas   "C:Users\r.nada\Downloads\\KMSAuto Net 2015 v1.3.5 Portable\KMSAuto Net 2015 v1.3.5 Portable\KMSAuto Net.exe"
#########################################################################################################################################



#Delete Files
#$delitem = "C:\Script"
#if([System.IO.Directory]::Exists($delitem))
#{
#"true"
#Write-Output "Folder is found" 
#Remove-Item -Force $delitem 
#Write-Output "Files are deleted"
#}
#else {
#return
#}

Exit
}

