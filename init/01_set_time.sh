#!/bin/bash
# 01_set_time.sh

if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
	echo "Setzen der Zeitzone auf: $TZ"
	echo $TZ > /etc/timezone
	ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
	dpkg-reconfigure tzdata
	echo "Datum: `date`"
fi
