#!/bin/bash

# by Travelling Tech Guy
# 28th of August 2020
# travellingtechguy.blog

# This script will grab all useful information on a macOS system to troubleshoot FileVault

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
echo $currentDate

currentFullDate=$(date)
echo $currentFullDate

loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
echo $loggedInUser

serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
echo $serial

computerName=$(scutil --get ComputerName)
echo $computerName

osVer=${1-$(sw_vers -productVersion)}
echo $osVer

build=${1-$(sw_vers -buildVersion)}
echo $build

fdeSetupStatus=`/usr/bin/fdesetup status`
echo "$fdeSetupStatus"

diskUtil=`/usr/sbin/diskutil apfs listusers /`
echo "$diskUtil"

fdeSetup=`/usr/bin/fdesetup list -extended`
echo "$fdeSetup"

bootStrap=`/usr/bin/profiles status -type bootstraptoken`
echo "$bootStrap"

deferralInfo=`/usr/bin/fdesetup showdeferralinfo`
echo "$deferralInfo"

echo "$deferralInfo" | sed -e 's/.*OutputPath = \"\(.*\)\";/\1/' | sed -n '3 p'

outputPath=$(echo "$deferralInfo"  | sed -e 's/.*OutputPath = \"\(.*\)\";/\1/' | sed -n '3 p')
echo $outputPath

outputPathContent=$(cat $outputPath)

# Create dated file
rm -rf /Users/$loggedInUser/Desktop/reportFV-$serial-$currentDate.txt
touch /Users/$loggedInUser/Desktop/reportFV-$serial-$currentDate.txt
reportFile="/Users/$loggedInUser/Desktop/reportFV-$serial-$currentDate.txt"

##### PRINT INFO TO FILE #####
echo "################" >> $reportFile
echo "FileVault Report" >> $reportFile
echo "################" >> $reportFile
echo >> $reportFile
echo >> $reportFile
echo "Date: 	"$currentFullDate >> $reportFile
echo "---------------------------------------------" >> $reportFile
echo "Serial Number:	"$serial >> $reportFile
echo "Computer Name:	"$computerName >> $reportFile
echo "macOS Version:	"$osVer >> $reportFile
echo "macOS Build:	"$build >> $reportFile
echo "---------------------------------------------" >> $reportFile
echo >> $reportFile
echo "----------------" >> $reportFile
echo "FileVault Status" >> $reportFile
echo "----------------" >> $reportFile
	echo "(fdesetup status)" >> $reportFile
	echo >> $reportFile
	echo "$fdeSetupStatus" >> $reportFile
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
	echo "($outputPath)" >> $reportFile
	echo >> $reportFile
	echo "$outputPathContent" >> $reportFile

echo >> $reportFile
echo >> $reportFile
echo "#############################################" >> $reportFile
echo "Report script provided by Travelling Tech Guy" >> $reportFile
echo "GitHub: https://github.com/TravellingTechGuy/reportFileVault" >> $reportFile
echo "#############################################" >> $reportFile
