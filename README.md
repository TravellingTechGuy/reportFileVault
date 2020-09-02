# reportFileVault
Script to grab all FileVault information for troubleshooting

This can be executed locally with 'sudo' or via a Jamf Pro Policy.

The script will put a timestamped .txt file on the logged-in user's Desktop

Latest version: V2.2

################
FileVault Report
################

########################################################
WARNING: this file may contain CONFIDENTIAL INFORMATION!
DELETE unwanted information before sharing!
DELETE file from Mac when not needed anymore!
########################################################

Date: 	Sun Aug 30 12:40:53 CEST 2020
---------------------------------------------
Serial Number:	XXX
Computer Name:	Frederick’s MacBook Pro
macOS Version:	10.15.6
macOS Build:	19G2021
---------------------------------------------

---------------
Logged In User:	frederick.abeloos
---------------

Is mobile account:	NO

Is admin account:	YES 

---------------
Mobile Accounts
---------------
--------------
Local Accounts
--------------

frederick.abeloos
ttg

--------------
Admin Accounts
--------------

frederick.abeloos
ttg

------------------
Managed Admin Info
------------------

----------------
FileVault Status
----------------
(fdesetup status)

FileVault is On.
FileVault master keychain appears to be installed.

------------------
Recovery Partition
------------------
(/usr/sbin/diskutil list | grep Recovery)

   3:                APFS Volume Recovery                528.9 MB   disk1s3

-------------------------
Secure Tokens - Disk Util
-------------------------
(disktutil apfs listusers /)

Cryptographic users for disk1s5 (4 found)
|
+-- FB756838-XXXX-XXXX-XXXX-40FB5E7D5D3F
|   Type: Local Open Directory User
|
+-- EBC6C064-XXXX-XXXX-XXXX-00306543ECAC
|   Type: Personal Recovery User
|
+-- C22BDCD3-XXXX-XXXX-XXXX-65D3332605C3
|   Type: Local Open Directory User
|
+-- 2457711A-XXXX-XXXX-XXXX-F48A571D5036
    Type: MDM Bootstrap Token External Key
 

------------------------
Secure Tokens - fdesetup
------------------------
(sudo fdesetup list -extended)

ESCROW  UUID                                                                     TYPE USER
        FB756838-XXXX-XXXX-XXXX-40FB5E7D5D3F                                  OS User frederick.abeloos
        EBC6C064-XXXX-XXXX-XXXX-00306543ECAC                 Personal Recovery Record
        C22BDCD3-XXXX-XXXX-XXXX-65D3332605C3                                  OS User ttg
        2457711A-XXXX-XXXX-XXXX-F48A571D5036                          Bootstrap Token

---------
BOOTSTRAP
---------
(sudo profiles status -type bootstraptoken)

profiles: Bootstrap Token supported on server: NO

-------------
Deferral Info
-------------
(sudo fdesetup showdeferralinfo)

{
    Defer = 1;
    OutputPath = "/var/db/ConfigurationProfiles/fdesetup.plist";
    ProfileUUID = "418DEB1B-XXXX-XXXX-XXXX-60BC894B1558";
    ShowRecoveryKey = 1;
    Usernames =     (
    );
}

----------------------
Content of OutPut Path
----------------------
(/var/db/ConfigurationProfiles/fdesetup.plist)

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>EnabledDate</key>
	<string>2019-11-04 18:06:29 +0100</string>
	<key>EnabledUser</key>
	<string>frederick.abeloos</string>
	<key>HardwareUUID</key>
	<string>F6329A14-XXXX-XXXX-XXXX-E831DB218AB5</string>
	<key>RecoveryKey</key>
	<string>3QKM-XXXX-XXXX-XXXX-XXXX-XXXX</string>
	<key>SerialNumber</key>
	<string>XXXX</string>
</dict>
</plist>

----------------------------
Personal Recovery Key: true
----------------------------

PRK found in OutPut Path:	3QKM-XXXX-XXXX-XXXX-XXXX-Q4AB

PRK Valid:	true

----------------------------------
Institutional Recovery Key: false
----------------------------------



############################################################
Report script provided by Travelling Tech Guy
Blog: https://travellingtechguy.blog
GitHub: https://github.com/TravellingTechGuy/reportFileVault
############################################################

