#!/usr/bin/bash

#Austin Pasquel. Bloomsburg Univeristy of Pennsylvania.
#Simple BASH Script for recovering file system of a Virtual Disk Image
#Produces hash log and filesystem image
#NOTE: If for forensics usage please interpret the VDI Header as there is important metadata stored there.

usage() {

  echo "$0 USAGE: ./VDItoRaw.sh <VDI FileName> <name of new imagefile>"
  echo "Simple BASH Script for recovering file system of a Virtual Disk Image"
}

if ! type dcfldd > /dev/null; then
	echo "Script utilizes dcfldd by the Department of Defense Computer Forensics Lab"
  echo "Installing Now"
  sudo apt install dcfldd
fi

if [  $# -le 1 ] ; then
	usage
	exit 1
fi

if file $1 | grep -q "<<< Oracle VM VirtualBox Disk Image >>>" ; then
  dcfldd if=$1 of=$2 bs=512 skip=4096 hash=md5 hashwindow=1G hashlog=Hashlog.txt
  echo "Calculating and Verifying md5 hashes- This may take some time"
  HASH1=$(dd if=$1 bs=512 skip=4096 | md5sum)
  HASH2=$(dd if=$2 | md5sum)
  echo 'md5 of VDI file is ' $HASH1
  echo 'md5 of Raw is ' $HASH2
  if [ "$HASH1"="$HASH2" ] ; then
    echo "MD5 Hashes Match!"
  else
    echo "ERROR HASHES DO NOT MATCH"
  fi
else
  echo "not a Virtual Disk Image File"
fi
