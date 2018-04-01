#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

quote=$'\047'
dquote=$'\042'
DATE=$(date "+%s%N")
ARGS=2
#Checking amount of  input parameters

if [ $# -ne "$ARGS"  ]
then
  echo "ERROR: Bad amount of arguments!" 1>&2
  exit 1
fi

#Checking for the existence of the first argument
CHECK=$(LANG=en_US stat --format "%F" "$1" 2>/dev/null)
if  [ -z  "$CHECK" ];then
	echo "ERROR: No such directory or file!" 1>&2
	exit 1
fi
if [[ "$1" != /* ]]
then
        echo "ERROR: Wrong path!" 1>&2
        exit 1
fi

#Checking for secong argument
VAR=$2
for ((i=0; $i<${#VAR}; i=$(($i+1))))
do
	if  [[ "${VAR:$i:1}" != [[:digit:]] ]];then
		echo "ERROR: $2 is not a positive integer!" 1>&2
		exit 1
	fi
done

# Directory for putting a backups (check on existing)
DBK="/tmp/backup/"
if ! [ -d "$DBK" ];then
   	if ! [ -d "/tmp" ];then
		mkdir "/tmp"
	fi
	mkdir "$DBK"
fi

#Backup
DIR=$(echo "$1" | sed -r 's/^\/+//' | sed -r 's/\/$//g')
BAC_DIR=$(echo  "$DIR" | sed -r 's/\/+/-/g')
BACKUP_DIR="$BAC_DIR$DATE.tar.gz"

tar -czf "$DBK$BACKUP_DIR" "$1" 2>/dev/null

# Error during backup (condition)
STATUS=$?
if [[ $STATUS != 0 ]]; then
       echo "ERROR: Backup doesn"$quote"t finish!" 1>&2
fi

#Delete old archives
CLEAR=$(ls -scl |  find   "$DBK""$BAC_DIR"* | head -n -"$2")
OLDIFS=$IFS
IFS=$'\n'
for var in $CLEAR
do
	rm -f "$var"
done
IFS=$OLDIFS







