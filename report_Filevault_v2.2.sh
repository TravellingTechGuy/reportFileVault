#!/bin/bash

# by Travelling Tech Guy
# 28th of August 2020
# travellingtechguy.blog

# This script will grab all useful information on a macOS system to throubleshoot FileVault

# Output will be written to a .txt file on the Desktop of the logged-in user

###### WARNING #####
# THIS SCRIPT WILL DISCLOSE CONFIDENTIAL INFORMATION LIKE:
# Usernames
# FileVault Recovery Keys
# SecureToken-enabled accounts

# !!! REMOVE THE INFORMATION YOU DO NOT WANT TO SHARE
# !!! DELETE THE FILE FROM THE DESKTOP WHEN DONE

# variables

currentDate=$(date "+%d%m%Y_%H%M")
#echo $currentDate

currentFullDate=$(date)
#echo $currentFullDate

loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
#echo $loggedInUser

serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
#echo $serial

computerName=$(scutil --get ComputerName)
#echo $computerName

osVer=$(sw_vers -productVersion)
#echo $osVer

build=$(sw_vers -buildVersion)
#echo $build

fdeSetupStatus=`/usr/bin/fdesetup status`
#echo "$fdeSetupStatus"

diskUtil=`/usr/sbin/diskutil apfs listusers /`
#echo "$diskUtil"

fdeSetup=`/usr/bin/fdesetup list -extended`
#echo "$fdeSetup"

bootStrap=`/usr/bin/profiles status -type bootstraptoken`
#echo "$bootStrap"

#echo "Deferral Info:"
deferralInfo=`/usr/bin/fdesetup showdeferralinfo`

#echo "$deferralInfo"

outputPath=""
outputPathContent=""
prkFound=""

prkCheck=`fdesetup haspersonalrecoverykey`
#echo "$prkCheck"

irkCheck=`fdesetup hasinstitutionalrecoverykey`
#echo "$irkCheck"

PRKValidation=""

mobileAccounts=`dscl . list /Users OriginalNodeName | awk '{print $1}' 2>/dev/null`
#echo "$mobileAccounts"

isMobile=`dscl . read /Users/$loggedInUser OriginalNodeName 2>/dev/null`
#echo "$isMobile"

isAdmin=`/usr/sbin/dseditgroup -o checkmember -m $loggedInUser admin / 2>&1`
#echo "$isAdmin"

setupUserFile="/var/db/ConfigurationProfiles/Settings/.setupUser"

localAccounts=`dscl . list /Users UniqueID | awk '$2 > 500 && $2 < 1000 { print $1 }'`

recoveryPartition=`/usr/sbin/diskutil list | grep "Recovery"`

# Create dated file
rm -rf /Users/$loggedInUser/Desktop/reportFV-$serial-$currentDate.txt
touch /Users/$loggedInUser/Desktop/reportFV-$serial-$currentDate.txt
reportFile="/Users/$loggedInUser/Desktop/reportFV-$serial-$currentDate.txt"

echo " "
echo " Creating timestamped report file on Desktop"
echo " --> deleting previous file with same timestamp"

##### PRINT INFO TO FILE #####
echo "################" >> $reportFile
echo "FileVault Report" >> $reportFile
echo "################" >> $reportFile
echo >> $reportFile

echo "########################################################" >> $reportFile
echo "WARNING: this file may contain CONFIDENTIAL INFORMATION!" >> $reportFile
echo "DELETE unwanted information before sharing!" >> $reportFile
echo "DELETE file from Mac when not needed anymore!" >> $reportFile
echo "########################################################" >> $reportFile

echo >> $reportFile

echo "Date: 	"$currentFullDate >> $reportFile
echo "---------------------------------------------" >> $reportFile
echo "Serial Number:	"$serial >> $reportFile
echo "Computer Name:	"$computerName >> $reportFile
echo "macOS Version:	"$osVer >> $reportFile
echo "macOS Build:	"$build >> $reportFile
echo "---------------------------------------------" >> $reportFile
echo >> $reportFile
echo "---------------" >> $reportFile
echo "Logged In User:	"$loggedInUser >> $reportFile
echo "---------------" >> $reportFile
echo >> $reportFile

if [ "$isMobile" == "" ]; then

	echo "Is mobile account:	NO" >> $reportFile
	echo >> $reportFile

else
	echo "Is mobile account:	YES" >> $reportFile
	echo >> $reportFile
fi

if [[ "$isAdmin" =~ "yes" ]]; then

	echo "Is admin account:	YES" >> $reportFile
	echo >> $reportFile

else

	echo "Is admin account:	NO" >> $reportFile
	echo >> $reportFile
fi


echo "---------------" >> $reportFile
echo "Mobile Accounts" >> $reportFile
echo "---------------" >> $reportFile
echo >> $reportFile
echo "$mobileAccounts" >> $reportFile
echo >> $reportFile

echo "--------------" >> $reportFile
echo "Local Accounts" >> $reportFile
echo "--------------" >> $reportFile
echo >> $reportFile
echo "$localAccounts" >> $reportFile
echo >> $reportFile

echo "--------------" >> $reportFile
echo "Admin Accounts" >> $reportFile
echo "--------------" >> $reportFile
echo >> $reportFile

listAdmins=()

for username in $(dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }'); do

	if [[ $(dsmemberutil checkmembership -U "${username}" -G admin) != *not* ]]; then
		listAdmins+=("${username}")
	fi
done

for word in ${listAdmins[@]}; do
	echo "$word" >> $reportFile
done

echo >> $reportFile

echo "------------------" >> $reportFile
echo "Managed Admin Info" >> $reportFile
echo "------------------" >> $reportFile
	echo >> $reportFile

    if [[ -f "$setupUserFile" ]]; then

    echo "$setupUserFile" >> $reportFile
	echo >> $reportFile
    setupUserContent=$(cat $setupUserFile)
    echo "$setupUserContent" >> $reportFile
    echo >> $reportFile

	fi

echo "----------------" >> $reportFile
echo "FileVault Status" >> $reportFile
echo "----------------" >> $reportFile
	echo "(fdesetup status)" >> $reportFile
	echo >> $reportFile
	echo "$fdeSetupStatus" >> $reportFile
	echo >> $reportFile


echo "------------------" >> $reportFile
echo "Recovery Partition" >> $reportFile
echo "------------------" >> $reportFile
	echo "(/usr/sbin/diskutil list | grep "Recovery")" >> $reportFile
	echo >> $reportFile
	echo "$recoveryPartition" >> $reportFile
	echo >> $reportFile

echo "-------------------------" >> $reportFile
echo "Secure Tokens - Disk Util" >> $reportFile
echo "-------------------------" >> $reportFile
	echo "(disktutil apfs listusers /)" >> $reportFile
	echo >> $reportFile
	echo "$diskUtil" >> $reportFile
	echo >> $reportFile
echo "------------------------" >> $reportFile
echo "Secure Tokens - fdesetup" >> $reportFile
echo "------------------------" >> $reportFile
	echo "(sudo fdesetup list -extended)" >> $reportFile
	echo >> $reportFile
	echo "$fdeSetup" >> $reportFile
	echo >> $reportFile
echo "--------------------" >> $reportFile
echo "Secure Tokens - dscl" >> $reportFile
echo "--------------------" >> $reportFile
	echo "(dscl . -search Users AuthenticationAuthority "\;SecureToken\;")" >> $reportFile
	echo >> $reportFile
dsclSecureToken=`dscl . -search Users AuthenticationAuthority ";SecureToken;"`

	echo $dsclSecureToken >> $reportFile
	echo >> $reportFile

echo "---------" >> $reportFile
echo "BOOTSTRAP" >> $reportFile
echo "---------" >> $reportFile
	echo "(sudo profiles status -type bootstraptoken)" >> $reportFile
	echo >> $reportFile
	echo "$bootStrap" >> $reportFile
	echo >> $reportFile
echo "-------------" >> $reportFile
echo "Deferral Info" >> $reportFile
echo "-------------" >> $reportFile
	echo "(sudo fdesetup showdeferralinfo)" >> $reportFile
	echo >> $reportFile
	echo "$deferralInfo" >> $reportFile
	echo >> $reportFile
	echo "----------------------" >> $reportFile
	echo "Content of OutPut Path" >> $reportFile
	echo "----------------------" >> $reportFile

if [ "$deferralInfo" != "Not found." ]; then
	outputPath=$(echo "$deferralInfo"  | sed -e 's/.*OutputPath = \"\(.*\)\";/\1/' | sed -n '3 p')
    #echo "$outputPath"

    if [[ -f "$outputPath" ]]; then

		outputPathContent=$(cat $outputPath)

		echo "($outputPath)" >> $reportFile
		echo >> $reportFile
		echo "$outputPathContent" >> $reportFile
		echo >> $reportFile

		prkFound=`defaults read /var/db/ConfigurationProfiles/fdesetup.plist RecoveryKey`
		#echo "$prkFound"

	else
		echo >> $reportFile
		echo "Output file does not exist yet" >> $reportFile
		echo >> $reportFile
	fi

else
	echo >> $reportFile
	echo "No Deferral Info found" >> $reportFile
	echo >> $reportFile
fi

echo "----------------------------" >> $reportFile
echo "Personal Recovery Key: "$prkCheck >> $reportFile
echo "----------------------------" >> $reportFile
echo >> $reportFile

if [ "$deferralInfo" != "Not found." ]; then

	echo "PRK found in OutPut Path:	"$prkFound >> $reportFile
else
	echo "No PRK found - No Deferral Info" >> $reportFile
fi


validateRecovery () {

expect << EOF

spawn /usr/bin/fdesetup validaterecovery
expect "Enter the current recovery key:"
send "$prkFound\n"
expect
EOF

}

if [ "$prkCheck" == "true" ] && [ $prkFound != "" ]; then

	#echo "Checking PRK"

	tempOutput=`validateRecovery | awk {'print $1}'`
	#echo "Temp output:"
	PRKValidation=`echo $tempOutput | sed 's/spawn//g' | sed 's/Enter//g' | sed 's/ //g' | sed 's/://g'`
	#echo $PRKValidation

	echo >> $reportFile
	echo "PRK Valid:	"$PRKValidation >> $reportFile

fi


echo >> $reportFile

echo "----------------------------------" >> $reportFile
echo "Institutional Recovery Key: "$irkCheck >> $reportFile
echo "----------------------------------" >> $reportFile
echo >> $reportFile

echo >> $reportFile
echo >> $reportFile

echo " "

echo "DONE!"
echo " "
echo "################################################################"
echo "WARNING: the output file may contain CONFIDENTIAL INFORMATION!"
echo "DELETE unwanted information before sharing!"
echo "DELETE file from Mac when not needed anymore!"
echo "################################################################"
echo " "

echo "############################################################" >> $reportFile
echo "Report script provided by Travelling Tech Guy" >> $reportFile
echo "Blog: https://travellingtechguy.blog" >> $reportFile
echo "GitHub: https://github.com/TravellingTechGuy/reportFileVault" >> $reportFile
echo "############################################################" >> $reportFile