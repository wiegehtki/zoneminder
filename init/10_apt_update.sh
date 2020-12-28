#!/bin/sh
#
#10_apt_update.sh
#

# Update repositories
echo "Aktualiserungen werden durchegführt..."
apt-get update 2>&1 | tee /tmp/test_update

# Überprüfung auf Funtion der Updates.
if [ "`cat /tmp/test_update | grep 'Failed'`" = "" ]; then
	# Perform Upgrade
	apt -y upgrade -o Dpkg::Options::="--force-confold"

	# Clean + purge old/obsoleted packages
	apt -y autoremove
else
	echo "Warnung: Probleme beim Update, Internetverbindung ok?"
fi
