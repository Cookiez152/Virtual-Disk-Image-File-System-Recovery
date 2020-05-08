#!/usr/bin/bash

#Austin Pasquel. Bloomsburg Univeristy of Pennsylvania.
#Simple BASH Script for recovering file system of a Virtual Disk Image
#Produces hash log and filesystem image
#NOTE: If for forensics usage please interpret the VDI Header as there is important metadata stored there.

usage() {

  echo "$0 USAGE: ./VDItoRaw.sh <VDI FileName> <name of imagefile>"
  echo "Simple BASH Script for recovering file system of a Virtual Disk Image"
}

if ! type dcfldd > /dev/null; then
  echo "Script utilizes dcfldd by the Department of Defense Computer Forensics Lab"
  echo "Installing Now"
  sudo apt install dcfldd
fi

if [  $# -le 1 ]
	then
		usage
		exit 1
	fi

dcfldd if=$1 of=$2 bs=512 skip=4096 count=1 hash=md5 hashwindow=1G hashlog=VDIhashes.txt
