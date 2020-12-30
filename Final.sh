	

# Es wird empfohlen root als Benutzer zu verwenden 
Benutzer="root"
CUDA_Version=10.1.0
CUDA_Script=cuda_10.1.0_460.27.04_linux.run
CUDA_Pfad=/usr/local/cuda-11.2



if [ "$(whoami)" != $Benutzer ]; then
        echo $(date -u) "Script muss als Benutzer $Benutzer ausgeführt werden!"
        exit 255
fi

echo $(date -u) "Test auf bestehende FinalInstall.log"
                 test -f ~/FinalInstall.log && rm ~/FinalInstall.log

echo $(date -u) "FinalInstall.log anlegen"
                 touch ~/FinalInstall.log
				 
####################################################################################################################
# Ubuntu 18.04 notwendig
#
#
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "# Zoneminder - Objekterkennung mit OpenCV und YOLO. By WIEGEHTKI.DE                                                                 #" | tee -a  ~/Installation.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                                            #" | tee -a  ~/Installation.log
echo $(date -u) "#                                                                                                                                   #" | tee -a  ~/Installation.log
echo $(date -u) "# V0.0.9 (Rev a), 28.12.2020                                                                                                        #" | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "01 von 30: CUDA runterladen und samt Grafiktreiber installieren"  | tee -a  ~/FinalInstall.log
                cd ~
				wget https://developer.download.nvidia.com/compute/cuda/$CUDA_Version/local_installers/$CUDA_Script
				chmod +x $CUDA_Script
                ./$CUDA_Script --silent
echo $(date -u) "01.1 von 30: Check auf installierten Treiber"  | tee -a  ~/FinalInstall.log
				lshw -C display | tee -a  ~/FinalInstall.log
				
echo $(date -u) "01.2 von 30: CUDA Umgebung setzen"  | tee -a  ~/FinalInstall.log
                echo $CUDA_Pfad/lib64 >>  /etc/ld.so.conf
                ldconfig
                echo 'export PATH='$CUDA_Pfad'/bin:$PATH' >> ~/.bashrc
                echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
                echo 'cd ~' >> ~/.bashrc
                source ~/.bashrc

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "02 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log
                export DEBCONF_NONINTERACTIVE_SEEN="true"
                export DEBIAN_FRONTEND="noninteractive"
                export DISABLE_SSH="true"
                export HOME="/root"
                export LC_ALL="C.UTF-8"
                export LANG="en_US.UTF-8"
                export LANGUAGE="en_US.UTF-8"
                export TZ="Etc/UTC"
                export TERM="xterm"
                export PHP_VERS="7.4"
                export ZM_VERS="master"
                export SHMEM="50%"
                export PUID="99"
                export PGID="100"
                export TZ="Europe/Berlin" 
                export SHMEM="50%" 
                export PUID="99" 
                export PGID="100" 
                export INSTALL_HOOK="1" 
                export INSTALL_FACE="1" 
                export INSTALL_TINY_YOLOV3="1" 
                export INSTALL_YOLOV3="1" 
                export INSTALL_TINY_YOLOV4="1" 
                export INSTALL_YOLOV4="1" 
                export MULTI_PORT_START="10" 
                export MULTI_PORT_END="0" 

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "05 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log

                #mkdir /mnt/cache/appdata/Zoneminder

                cd ~
                #git clone https://github.com/dlandon/zoneminder.master-docker.git
                #cp -r zoneminder/init/. /etc/my_init.d/.                                
                cp -r zoneminder/defaults/. /root/.

                add-apt-repository -y ppa:iconnor/zoneminder-$ZM_VERS 
	            LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php 
	            add-apt-repository ppa:jonathonf/ffmpeg-4 
	            apt update 
	            apt -y upgrade -o Dpkg::Options::="--force-confold" 
	            apt -y dist-upgrade -o Dpkg::Options::="--force-confold" 
	            apt -y install apache2 mariadb-server 
	            apt -y install ssmtp mailutils net-tools wget sudo make 
	            apt -y install php$PHP_VERS php$PHP_VERS-fpm libapache2-mod-php$PHP_VERS php$PHP_VERS-mysql php$PHP_VERS-gd && \
	            apt -y install libcrypt-mysql-perl libyaml-perl libjson-perl libavutil-dev ffmpeg && \
	            apt -y install --no-install-recommends libvlc-dev libvlccore-dev vlc && \
	            apt -y install zoneminder

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "06 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log

                a2enmod proxy_fcgi setenvif	
                a2enconf php7.4-fpm
                systemctl reload apache2

                rm /etc/mysql/my.cnf 
	            cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/my.cnf 
	            adduser www-data video 
	            a2enmod php$PHP_VERS proxy_fcgi ssl rewrite expires headers 
	            a2enconf php$PHP_VERS-fpm zoneminder 
	            echo "extension=apcu.so" > /etc/php/$PHP_VERS/mods-available/apcu.ini 
	            echo "extension=mcrypt.so" > /etc/php/$PHP_VERS/mods-available/mcrypt.ini 
	            perl -MCPAN -e "force install Net::WebSocket::Server" 
	            perl -MCPAN -e "force install LWP::Protocol::https" 
	            perl -MCPAN -e "force install Config::IniFiles" 
                perl -MCPAN -e "force install Net::MQTT::Simple" 
                perl -MCPAN -e "force install Net::MQTT::Simple::Auth"

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "07 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log

                mysql -uroot -D zm -e "DROP DATABASE zm"
                cd /root 
                chown -R www-data:www-data /usr/share/zoneminder/ 
                echo "ServerName localhost" >> /etc/apache2/apache2.conf 
                sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/apache2/php.ini 
                service mysql start 
                mysql -uroot < /usr/share/zoneminder/db/zm_create.sql 
                mysql -uroot -e "grant all on zm.* to 'zmuser'@localhost identified by 'zmpass';" 
                mysqladmin -uroot reload 
                mysql -sfu root < "/root/defaults/mysql_secure_installation.sql" 
                rm mysql_secure_installation.sql 
                mysql -sfu root < "mysql_defaults.sql" 
                rm mysql_defaults.sql

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "08 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log
                mv /root/zoneminder /etc/init.d/zoneminder
                chmod +x /etc/init.d/zoneminder 
                service mysql restart 
                sleep 5 
                service apache2 restart 
                service zoneminder start
		
                systemd-tmpfiles --create zoneminder.conf 
                mv /root/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
                mkdir /etc/apache2/ssl/ 
                mkdir -p /var/lib/zmeventnotification/images 
                chown -R www-data:www-data /var/lib/zmeventnotification/ 
                chmod -R +x /etc/my_init.d/ 
                cp -p /etc/zm/zm.conf /root/zm.conf 
                echo $'#!/bin/sh\n\n/usr/bin/zmaudit.pl -f' >> /etc/cron.weekly/zmaudit 
                chmod +x /etc/cron.weekly/zmaudit 
                cp /etc/apache2/ports.conf /etc/apache2/ports.conf.default 
                cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default
	
echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "09 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log
                apt -y remove make
                apt -y clean 
                apt -y autoremove 
                rm -rf /tmp/* /var/tmp/* 
                chmod +x /etc/my_init.d/*.sh

                mkdir /config
                mkdir /var/cache/zoneminder

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "10 von 30: Uhrzeit setzen"  | tee -a  ~/FinalInstall.log
	
                if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
                    echo "Setzen der Zeitzone auf: $TZ"
                    echo $TZ > /etc/timezone
                    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
                    dpkg-reconfigure tzdata
                    echo "Datum: `date`"
                fi
	
                sed -i "s|^date.timezone =.*$|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/apache2/php.ini

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "11 von 30: Update der Repositories"  | tee -a  ~/FinalInstall.log
                echo "Aktualiserungen werden durchegführt..." | tee -a  ~/FinalInstall.log
                apt update 2>&1 | tee /tmp/test_update

                # Überprüfung auf Funtion der Updates.
                if [ "`cat /tmp/test_update | grep 'Failed'`" = "" ]; then
	                # Perform Upgrade
                    apt -y upgrade -o Dpkg::Options::="--force-confold"

                    # Clean + purge old/obsoleted packages
                    apt -y autoremove
                else
                    echo "Warnung: Probleme beim Update, Internetverbindung ok?" | tee -a  ~/FinalInstall.log
                fi

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "12 von 30: SSL-Zertifikate installieren"  | tee -a  ~/FinalInstall.log
                if [[ -f /config/keys/cert.key && -f /config/keys/cert.crt ]]; then
                    echo "using existing keys in \"/config/keys\""
                    if [[ ! -f /config/keys/ServerName ]]; then
                        echo "localhost" > /config/keys/ServerName
                    fi
                    SERVER=`cat /config/keys/ServerName`
                    sed -i "/ServerName/c\ServerName $SERVER" /etc/apache2/apache2.conf
                else
                    echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
                    mkdir -p /config/keys
                    echo "localhost" >> /config/keys/ServerName
                    openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "/C=US/ST=NY/L=New York/O=Zoneminder/OU=Zoneminder/CN=localhost"
                fi

                chown root:root /config/keys
                chmod 777 /config/keys

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "13 von 30: OpenCV Download und compilieren, dito YOLO etc."  | tee -a  ~/FinalInstall.log
 			    # Search for config files, if they don't exist, create the default ones
                if [ ! -d /config/conf ]; then
                	echo "Conf-Ordner erstellen" | tee -a  ~/FinalInstall.log
                	mkdir /config/conf
                else
                	echo "Vorhandenen conf-Ordner verwenden" | tee -a  ~/FinalInstall.log
                fi
                
                if [ -f /root/zm.conf ]; then
                	echo "Verschieben von zm.conf in den Ordner config" | tee -a  ~/FinalInstall.log
                	mv /root/zm.conf /config/conf/zm.default
                	cp /etc/zm/conf.d/README /config/conf/README
                else
                	echo "Datei zm.conf bereits verschoben" | tee -a  ~/FinalInstall.log
                fi
 
echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "14 von 30: Eventserver runterladen und installieren"  | tee -a  ~/FinalInstall.log
  
                # Get the latest ES bundle
                cd /root
                cp /root/zoneminder/zmeventnotification/EventServer.tgz .
				if [ -f EventServer.tgz ]; then
                	tar -xf EventServer.tgz
                	rm EventServer.tgz
                else
                	echo "Fehler: ES - Server kann nicht runtergeladen werden." | tee -a  ~/FinalInstall.log
                fi
                
echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "15 von 30: Eventserver - Config"  | tee -a  ~/FinalInstall.log
                if [ -f /root/zmeventnotification/zmeventnotification.ini ]; then
                	echo "zmeventnotification.ini verschieben" | tee -a  ~/FinalInstall.log
                	cp /root/zmeventnotification/zmeventnotification.ini /config/zmeventnotification.ini.default
                	if [ ! -f /config/zmeventnotification.ini ]; then
                		mv /root/zmeventnotification/zmeventnotification.ini /config/zmeventnotification.ini
                	else
                		rm -rf /root/zmeventnotification/zmeventnotification.ini
                	fi
                else
                	echo "Datei zmeventnotification.ini bereits verschoben" | tee -a  ~/FinalInstall.log
                fi

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "16 von 30: Secrets.ini und OpenCV"  | tee -a  ~/FinalInstall.log
                if [ -f /root/zmeventnotification/secrets.ini ]; then
                	echo "Verschieben von secrets.ini"  | tee -a  ~/FinalInstall.log
                	cp /root/zmeventnotification/secrets.ini /config/secrets.ini.default
                	if [ ! -f /config/secrets.ini ]; then
                		mv /root/zmeventnotification/secrets.ini /config/secrets.ini
                	else
                		rm -rf /root/zmeventnotification/secrets.ini
                	fi
                else
                	echo "Datei secrets.ini bereits verschoben"  | tee -a  ~/FinalInstall.log
                fi
                
                # Create opencv folder if it doesn't exist
                if [ ! -d /config/opencv ]; then
                	echo "Erstellen des opencv-Ordners im config-Ordner" | tee -a  ~/FinalInstall.log
                	mkdir /config/opencv
                fi
                
                # Handle the opencv.sh file
                if [ -f /root/zmeventnotification/opencv.sh ]; then
                	echo "opencv.sh verschieben" | tee -a  ~/FinalInstall.log
                	cp /root/zmeventnotification/opencv.sh /config/opencv/opencv.sh.default
                	if [ ! -f /config/opencv/opencv.sh ]; then
                		mv /root/zmeventnotification/opencv.sh /config/opencv/opencv.sh
                	else
                		rm -rf /root/zmeventnotification/opencv.sh
                	fi
                else
                	echo "Datei opencv.sh bereits verschoben" | tee -a  ~/FinalInstall.log
                fi
                
                # Handle the debug_opencv.sh file
                if [ -f /root/zmeventnotification/debug_opencv.sh ]; then
                	echo "Verschieben von debug_opencv.sh" | tee -a  ~/FinalInstall.log
                	mv /root/zmeventnotification/debug_opencv.sh /config/opencv/debug_opencv.sh
                else
                	echo "Datei debug_opencv.sh bereits verschoben" | tee -a  ~/FinalInstall.log
                fi
                
                if [ ! -f /config/opencv/opencv_ok ]; then
                	echo "no" > /config/opencv/opencv_ok
                fi
                
                # Handle the zmeventnotification.pl
                if [ -f /root/zmeventnotification/zmeventnotification.pl ]; then
                	echo "Verschieben des Ereignisbenachrichtigungsservers" | tee -a  ~/FinalInstall.log
                	mv /root/zmeventnotification/zmeventnotification.pl /usr/bin
                	chmod +x /usr/bin/zmeventnotification.pl 2>/dev/null
                else
                	echo "Ereignisbenachrichtigungsserver bereits verschoben" | tee -a  ~/FinalInstall.log
                fi
                
                # Handle the pushapi_pushover.py
                if [ -f /root/zmeventnotification/pushapi_pushover.py ]; then
                	echo "Verschieben der Pushover-Api" | tee -a  ~/FinalInstall.log
                	mkdir -p /var/lib/zmeventnotification/bin/
                	mv /root/zmeventnotification/pushapi_pushover.py /var/lib/zmeventnotification/bin/
                	chmod +x /var/lib/zmeventnotification/bin/pushapi_pushover.py 2>/dev/null
                else
                	echo "Pushover api bereits verschoben" | tee -a  ~/FinalInstall.log
                fi
                
                # Move ssmtp configuration if it doesn't exist
                if [ ! -d /config/ssmtp ]; then
                	echo "Verschieben von ssmtp in den Ordner config" | tee -a  ~/FinalInstall.log
                	cp -p -R /etc/ssmtp/ /config/
                else
                	echo "Vorhandenen ssmtp-Ordner verwenden" | tee -a  ~/FinalInstall.log
                fi
                
                # Move mysql database if it doesn't exit
                if [ ! -d /config/mysql/mysql ]; then
                	echo "Verschieben von mysql in den config-Ordner" | tee -a  ~/FinalInstall.log
                	rm -rf /config/mysql
                	cp -p -R /var/lib/mysql /config/
                else
                	echo "Vorhandenen mysql-Datenbankordner verwenden" | tee -a  ~/FinalInstall.log
                fi
                
                # files and directories no longer exposed at config.
                rm -rf /config/perl5/
                rm -rf /config/zmeventnotification/
                rm -rf /config/zmeventnotification.pl
                rm -rf /config/skins
                rm -rf /config/zm.conf
                
                # Create Control folder if it doesn't exist and copy files into image
                if [ ! -d /config/control ]; then
                	echo "Control-Ordner im Config-Ordner anlegen" | tee -a  ~/FinalInstall.log
                	mkdir /config/control
                else
                	echo "Copy /config/control/ scripts to /usr/share/perl5/ZoneMinder/Control/"
                	cp /config/control/*.pm /usr/share/perl5/ZoneMinder/Control/ 2>/dev/null
                	chown root:root /usr/share/perl5/ZoneMinder/Control/* 2>/dev/null
                	chmod 644 /usr/share/perl5/ZoneMinder/Control/* 2>/dev/null
                fi
                
                # Copy conf files if there are any
                if [ -d /config/conf ]; then
                	echo "Copy /config/conf/ scripts to /etc/zm/conf.d/"
                	cp /config/conf/*.conf /etc/zm/conf.d/ 2>/dev/null
                	chown root:root /etc/zm/conf.d* 2>/dev/null
                	chmod 640 /etc/conf.d/* 2>/dev/null
                fi
                
                echo "Creating symbolink links"
                # security certificate keys
                rm -rf /etc/apache2/ssl/zoneminder.crt
                ln -sf /config/keys/cert.crt /etc/apache2/ssl/zoneminder.crt
                rm -rf /etc/apache2/ssl/zoneminder.key
                ln -sf /config/keys/cert.key /etc/apache2/ssl/zoneminder.key
                mkdir -p /var/lib/zmeventnotification/push
                mkdir -p /config/push
                rm -rf /var/lib/zmeventnotification/push/tokens.txt
                ln -sf /config/push/tokens.txt /var/lib/zmeventnotification/push/tokens.txt
                
                # ssmtp
                rm -r /etc/ssmtp 
                ln -s /config/ssmtp /etc/ssmtp
                
                # mysql
                rm -r /var/lib/mysql
                ln -s /config/mysql /var/lib/mysql
                
                # Set ownership for unRAID
                PUID=${PUID:-99}
                PGID=${PGID:-100}
                usermod -o -u $PUID nobody
                usermod -g $PGID nobody
                usermod -d /config nobody
                
                # Set ownership for mail
                usermod -a -G mail www-data
                
                # Change some ownership and permissions
                chown -R mysql:mysql /config/mysql
                chown -R mysql:mysql /var/lib/mysql
                chown -R $PUID:$PGID /config/conf
                chmod 777 /config/conf
                chmod 666 /config/conf/*
                chown -R $PUID:$PGID /config/control
                chmod 777 /config/control
                chmod 666 -R /config/control/
                chown -R $PUID:$PGID /config/ssmtp
                chmod -R 777 /config/ssmtp
                chown -R $PUID:$PGID /config/zmeventnotification.*
                chmod 666 /config/zmeventnotification.*
                chown -R $PUID:$PGID /config/secrets.ini
                chmod 666 /config/secrets.ini
                chown -R $PUID:$PGID /config/opencv
                chmod 777 /config/opencv
                chmod 666 /config/opencv/*
                chown -R $PUID:$PGID /config/keys
                chmod 777 /config/keys
                chmod 666 /config/keys/*
                chown -R www-data:www-data /config/push/
                chown -R www-data:www-data /var/lib/zmeventnotification/
                chmod +x /config/opencv/opencv.sh
                chmod +x /config/opencv/debug_opencv.sh
                chmod +x /config/opencv/opencv.sh.default
                
                # Create events folder
                if [ ! -d /var/cache/zoneminder/events ]; then
                	echo "Ordner für Ereignisse erstellen" | tee -a  ~/FinalInstall.log
                	mkdir /var/cache/zoneminder/events
                	chown -R www-data:www-data /var/cache/zoneminder/events
                	chmod -R 777 /var/cache/zoneminder/events
                else
                	echo "Vorhandenes Datenverzeichnis für Ereignisse verwenden" | tee -a  ~/FinalInstall.log
                
                	# Check the ownership on the /var/cache/zoneminder/events directory
                	if [ `stat -c '%U:%G' /var/cache/zoneminder/events` != 'www-data:www-data' ]; then
                		echo "Eigentümerschaft von /var/cache/zoneminder/events korrigieren..." | tee -a  ~/FinalInstall.log
                		chown -R www-data:www-data /var/cache/zoneminder/events
                	fi
                
                	# Check the permissions on the /var/cache/zoneminder/events directory
                	if [ `stat -c '%a' /var/cache/zoneminder/events` != '777' ]; then
                		echo "Korrektur der /var/cache/zoneminder/events-Berechtigungen..." | tee -a  ~/FinalInstall.log
                		chmod -R 777 /var/cache/zoneminder/events
                	fi
                fi
                
                # Create images folder
                if [ ! -d /var/cache/zoneminder/images ]; then
                	echo "Bilderordner erstellen" | tee -a  ~/FinalInstall.log
                	mkdir /var/cache/zoneminder/images
                	chown -R www-data:www-data /var/cache/zoneminder/images
                	chmod -R 777 /var/cache/zoneminder/images
                else
                	echo "Vorhandenes Datenverzeichnis für Bilder verwenden" | tee -a  ~/FinalInstall.log
                
                	# Check the ownership on the /var/cache/zoneminder/images directory
                	if [ `stat -c '%U:%G' /var/cache/zoneminder/images` != 'www-data:www-data' ]; then
                		echo "Eigentümerschaft von /var/cache/zoneminder/images korrigieren..." | tee -a  ~/FinalInstall.log
                		chown -R www-data:www-data /var/cache/zoneminder/images
                	fi
                
                	# Check the permissions on the /var/cache/zoneminder/images directory
                	if [ `stat -c '%a' /var/cache/zoneminder/images` != '777' ]; then
                		echo "Korrektur der /var/cache/zoneminder/images-Berechtigungen..." | tee -a  ~/FinalInstall.log
                		chmod -R 777 /var/cache/zoneminder/images
                	fi
                fi
                
                # Create temp folder
                if [ ! -d /var/cache/zoneminder/temp ]; then
                	echo "Temporären Ordner erstellen" | tee -a  ~/FinalInstall.log
                	mkdir /var/cache/zoneminder/temp
                	chown -R www-data:www-data /var/cache/zoneminder/temp
                	chmod -R 777 /var/cache/zoneminder/temp
                else
                	echo "Vorhandenes Datenverzeichnis für temp verwenden" | tee -a  ~/FinalInstall.log
                
                	# Check the ownership on the /var/cache/zoneminder/temp directory
                	if [ `stat -c '%U:%G' /var/cache/zoneminder/temp` != 'www-data:www-data' ]; then
                		echo "Eigentümerschaft von /var/cache/zoneminder/temp korrigieren..."  | tee -a  ~/FinalInstall.log
                		chown -R www-data:www-data /var/cache/zoneminder/temp
                	fi
                
                	# Check the permissions on the /var/cache/zoneminder/temp directory
                	if [ `stat -c '%a' /var/cache/zoneminder/temp` != '777' ]; then
                		echo "Korrektur der /var/cache/zoneminder/temp-Berechtigungen..." | tee -a  ~/FinalInstall.log
                		chmod -R 777 /var/cache/zoneminder/temp
                	fi
                fi
                
                # Create cache folder
                if [ ! -d /var/cache/zoneminder/cache ]; then
                	echo "Cache-Ordner erstellen" | tee -a  ~/FinalInstall.log
                	mkdir /var/cache/zoneminder/cache
                	chown -R www-data:www-data /var/cache/zoneminder/cache
                	chmod -R 777 /var/cache/zoneminder/cache
                else
                	echo "Vorhandenes Datenverzeichnis für Cache verwenden" | tee -a  ~/FinalInstall.log
                
                	# Check the ownership on the /var/cache/zoneminder/cache directory
                	if [ `stat -c '%U:%G' /var/cache/zoneminder/cache` != 'www-data:www-data' ]; then
                		echo "Eigentümerschaft von /var/cache/zoneminder/cache korrigieren..." | tee -a  ~/FinalInstall.log
                		chown -R www-data:www-data /var/cache/zoneminder/cache
                	fi
                
                	# Check the permissions on the /var/cache/zoneminder/cache directory
                	if [ `stat -c '%a' /var/cache/zoneminder/cache` != '777' ]; then
                		echo "Korrektur der /var/cache/zoneminder/cache-Berechtigungen..." | tee -a  ~/FinalInstall.log
                		chmod -R 777 /var/cache/zoneminder/cache
                	fi
                fi
                
                # set user crontab entries
                crontab -r -u root
                if [ -f /config/cron ]; then
                	crontab -l -u root | cat - /config/cron | crontab -u root -
                fi
                
                # Symbolink for /config/zmeventnotification.ini
                ln -sf /config/zmeventnotification.ini /etc/zm/zmeventnotification.ini
                chown www-data:www-data /etc/zm/zmeventnotification.ini
                
                # Symbolink for /config/secrets.ini
                ln -sf /config/secrets.ini /etc/zm/
                
                # Fix memory issue
                echo "Setzen shared memory auf : $SHMEM of `awk '/MemTotal/ {print $2}' /proc/meminfo` bytes"  | tee -a  ~/FinalInstall.log
                umount /dev/shm
                mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${SHMEM} tmpfs /dev/shm
                
                # Set multi-ports in apache2 for ES.
                # Start with default configuration.
                cp /etc/apache2/ports.conf.default /etc/apache2/ports.conf
                cp /etc/apache2/sites-enabled/default-ssl.conf.default /etc/apache2/sites-enabled/default-ssl.conf
                
                if [ $((MULTI_PORT_START)) -gt 0 ] && [ $((MULTI_PORT_END)) -gt $((MULTI_PORT_START)) ]; then
                
                	echo "Einstellung ES-Multiport-Bereich von ${MULTI_PORT_START} bis ${MULTI_PORT_END}."  | tee -a  ~/FinalInstall.log
                
                	ORIG_VHOST="_default_:443"
                
                	NEW_VHOST=${ORIG_VHOST}
                	PORT=${MULTI_PORT_START}
                	while [[ ${PORT} -le ${MULTI_PORT_END} ]]; do
                	    egrep -sq "Listen ${PORT}" /etc/apache2/ports.conf || echo "Listen ${PORT}" >> /etc/apache2/ports.conf
                	    NEW_VHOST="${NEW_VHOST} _default_:${PORT}"
                	    PORT=$(($PORT + 1))
                	done
                
                	perl -pi -e "s/${ORIG_VHOST}/${NEW_VHOST}/ if (/<VirtualHost/);" /etc/apache2/sites-enabled/default-ssl.conf
                else
                	if [ $((MULTI_PORT_START)) -ne 0 ];then
                		echo "Multi-port error start ${MULTI_PORT_START}, end ${MULTI_PORT_END}."  | tee -a  ~/FinalInstall.log
                	fi
                fi
                
echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "15 von 30: Hook - Installation inklusive YOLO - Models"  | tee -a  ~/FinalInstall.log
                if [ "$INSTALL_HOOK" == "1" ]; then
                	echo "Installieren von Machine-Learning-Modulen & Hooks beginnt..."  | tee -a  ~/FinalInstall.log
                
                	if [ ! -f /root/setup.py ]; then
                		# If hook folder exists, copy files into image
                		if [ ! -d /config/hook ]; then
                			echo "Hook-Ordner im config-Ordner erstellen" | tee -a  ~/FinalInstall.log
                			mkdir /config/hook
                		fi
                
                		# Python modules needed for hook processing
                		apt -y install python3-pip cmake
                		apt -y install libopenblas-dev liblapack-dev libblas-dev
                        #UW Fix
                        pip3 install numpy scipy matplotlib ipython pandas sympy nose cython 
                
                		# pip3 will take care of installing dependent packages
                		pip3 install future
                		pip3 install /root/zmeventnotification
                
                		cd ~
                	    rm -rf /root/zmeventnotification/zmes_hook_helpers
                	fi
                
                	# Download models files
                	if [ "$INSTALL_TINY_YOLOV3" == "1" ]; then
                		if [ ! -d /config/hook/models/tinyyolov3 ]; then
                			echo "Herunterladen von Tiny Yolo-Models und Konfigurationen..." | tee -a  ~/FinalInstall.log
                			mkdir -p /config/hook/models/tinyyolov3
                			wget https://pjreddie.com/media/files/yolov3-tiny.weights -O /config/hook/models/tinyyolov3/yolov3-tiny.weights
                			wget https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3-tiny.cfg -O /config/hook/models/tinyyolov3/yolov3-tiny.cfg
                			wget https://raw.githubusercontent.com/pjreddie/darknet/master/data/coco.names -O /config/hook/models/tinyyolov3/coco.names
                		else
                			echo "Tiny Yolo V3-Dateien wurden bereits heruntergeladen, Skip...	" | tee -a  ~/FinalInstall.log
                		fi
                	fi
                
                	if [ "$INSTALL_YOLOV3" == "1" ]; then
                		if [ ! -d /config/hook/models/yolov3 ]; then
                			echo "Herunterladen von Yolo-Modellen und Konfigurationen..." | tee -a  ~/FinalInstall.log
                			mkdir -p /config/hook/models/yolov3
                			wget https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3.cfg -O /config/hook/models/yolov3/yolov3.cfg
                			wget https://raw.githubusercontent.com/pjreddie/darknet/master/data/coco.names -O /config/hook/models/yolov3/coco.names
                			wget https://pjreddie.com/media/files/yolov3.weights -O /config/hook/models/yolov3/yolov3.weights
                		else
                			echo "Yolo V3 files have already been downloaded, skipping..."  | tee -a  ~/FinalInstall.log
                	    fi
                	fi
                
                	if [ "$INSTALL_TINY_YOLOV4" == "1" ]; then
                		if [ ! -d /config/hook/models/tinyyolov4 ]; then
                			echo "Herunterladen von Tiny Yolo-Models und Konfigurationen..."  | tee -a  ~/FinalInstall.log
                			mkdir -p /config/hook/models/tinyyolov4
                			wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-tiny.weights -O /config/hook/models/tinyyolov4/yolov4-tiny.weights
                			wget https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4-tiny.cfg -O /config/hook/models/tinyyolov4/yolov4-tiny.cfg
                			wget https://raw.githubusercontent.com/pjreddie/darknet/master/data/coco.names -O /config/hook/models/tinyyolov4/coco.names
                		else
                			echo "Tiny Yolo V4-Dateien wurden bereits heruntergeladen, das Überspringen..."  | tee -a  ~/FinalInstall.log
                		fi
                	fi
                
                	if [ "$INSTALL_YOLOV4" == "1" ]; then
                		if [ ! -d /config/hook/models/yolov4 ]; then
                			echo "Herunterladen von Yolo-Modellen und Konfigurationen..."  | tee -a  ~/FinalInstall.log
                			mkdir -p /config/hook/models/yolov4
                			wget https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4.cfg -O /config/hook/models/yolov4/yolov4.cfg
                			wget https://raw.githubusercontent.com/pjreddie/darknet/master/data/coco.names -O /config/hook/models/yolov4/coco.names
                			wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights -O /config/hook/models/yolov4/yolov4.weights
                		else
                			echo "Yolo V4-Dateien wurden bereits heruntergeladen, Überspringen..."  | tee -a  ~/FinalInstall.log
                	    fi
                	fi
                
                	# Umgang mit der Datei objectconfig.ini
                	if [ -f /root/zmeventnotification/objectconfig.ini ]; then
                		echo "Moving objectconfig.ini"
                		cp /root/zmeventnotification/objectconfig.ini /config/hook/objectconfig.ini.default
                		if [ ! -f /config/hook/objectconfig.ini ]; then
                			mv /root/zmeventnotification/objectconfig.ini /config/hook/objectconfig.ini
                		else
                			rm -rf /root/zmeventnotification/objectconfig.ini
                		fi
                	else
                		echo "Datei objectconfig.ini bereits verschoben"
                	fi
                
                	# Handle the config_upgrade script
                	if [ -f /root/zmeventnotification/config_upgrade.py ]; then
                		echo "Verschieben von config_upgrade.py"
                		mv /root/zmeventnotification/config_upgrade.py /config/hook/config_upgrade.py
                		mv /root/zmeventnotification/config_upgrade.sh /config/hook/config_upgrade.sh
                		chmod +x /config/hook/config_upgrade.*
                	else
                		echo "Skript config_upgrade.py nicht gefunden"
                	fi
                
                	# Handle the zm_event_start.sh file
                	if [ -f /root/zmeventnotification/zm_event_start.sh ]; then
                		echo "Verschieben von zm_event_start.sh"
                		mv /root/zmeventnotification/zm_event_start.sh /config/hook/zm_event_start.sh
                	else
                		echo "Datei zm_event_start.sh bereits verschoben"
                	fi
                
                	# Handle the zm_event_end.sh file
                	if [ -f /root/zmeventnotification/zm_event_end.sh ]; then
                		echo "Verschieben von zm_event_end.sh"
                		mv /root/zmeventnotification/zm_event_end.sh /config/hook/zm_event_end.sh
                	else
                		echo "Datei zm_event_end.sh bereits verschoben"
                	fi
                
                	# Handle the zm_detect.py file
                	if [ -f /root/zmeventnotification/zm_detect.py ]; then
                		echo "Verschieben von zm_detect.py"
                		mv /root/zmeventnotification/zm_detect.py /config/hook/zm_detect.py
                	else
                		echo "Datei zm_detect.py bereits verschoben"
                	fi
                
                	# Handle the zm_train_faces.py file
                	if [ -f /root/zmeventnotification/zm_train_faces.py ]; then
                		echo "Verschieben von zm_train_faces.py"
                		mv /root/zmeventnotification/zm_train_faces.py /config/hook/zm_train_faces.py
                	else
                		echo "Datei zm_train_faces.py bereits verschoben"
                	fi
                
                	# Symbolic link for models in /config
                	rm -rf /var/lib/zmeventnotification/models
                	ln -sf /config/hook/models /var/lib/zmeventnotification/models
                	chown -R www-data:www-data /var/lib/zmeventnotification/models
                
                	# Symbolic link for known_faces in /config
                	rm -rf /var/lib/zmeventnotification/known_faces
                	ln -sf /config/hook/known_faces /var/lib/zmeventnotification/known_faces
                	chown -R www-data:www-data /var/lib/zmeventnotification/known_faces
                
                	# Symbolic link for unknown_faces in /config
                	rm -rf /var/lib/zmeventnotification/unknown_faces
                	ln -sf /config/hook/unknown_faces /var/lib/zmeventnotification/unknown_faces
                	chown -R www-data:www-data /var/lib/zmeventnotification/unknown_faces
                
                	# Symbolic link for misc in /config
                	rm -rf /var/lib/zmeventnotification/misc
                	ln -sf /config/hook/misc /var/lib/zmeventnotification/misc
                	chown -R www-data:www-data /var/lib/zmeventnotification/misc
                
                	# Create misc folder if it doesn't exist
                	if [ ! -d /config/hook/misc ]; then
                		echo "Ordner hook/misc im config-Ordner anlegen"
                		mkdir -p /config/hook/misc
                	fi
                
                	# Symbolic link for coral_edgetpu in /config
                	rm -rf /var/lib/zmeventnotification/coral_edgetpu
                	ln -sf /config/hook/coral_edgetpu /var/lib/zmeventnotification/coral_edgetpu
                	chown -R www-data:www-data /var/lib/zmeventnotification/coral_edgetpu
                
                	# Create coral_edgetpu folder if it doesn't exist
                	if [ ! -d /config/hook/coral_edgetpu ]; then
                		echo "Ordner hook/coral_edgetpu im Ordner config erstellen"
                		mkdir -p /config/hook/coral_edgetpu
                	fi
                
                	# Symbolic link for hook files in /config
                	mkdir -p /var/lib/zmeventnotification/bin
                	ln -sf /config/hook/zm_detect.py /var/lib/zmeventnotification/bin/zm_detect.py
                	ln -sf /config/hook/zm_train_faces.py /var/lib/zmeventnotification/bin/zm_train_faces.py
                	ln -sf /config/hook/zm_event_start.sh /var/lib/zmeventnotification/bin/zm_event_start.sh
                	ln -sf /config/hook/zm_event_end.sh /var/lib/zmeventnotification/bin/zm_event_end.sh
                	chmod +x /var/lib/zmeventnotification/bin/*
                	ln -sf /config/hook/objectconfig.ini /etc/zm/
                
                	if [ "$INSTALL_FACE" == "1" ] && [ -f /root/zmeventnotification/setup.py ]; then
                		# Create known_faces folder if it doesn't exist
                		if [ ! -d /config/hook/known_faces ]; then
                			echo "Ordner hook/known_faces im Ordner config anlegen"
                			mkdir -p /config/hook/known_faces
                		fi
                
                		# Create known_faces folder if it doesn't exist
                		if [ ! -d /config/hook/known_faces ]; then
                			echo "Ordner hook/known_faces im Ordner config anlegen"
                			mkdir -p /config/hook/known_faces
                		fi
                
                		# Create unknown_faces folder if it doesn't exist
                		if [ ! -d /config/hook/unknown_faces ]; then
                			echo "Ordner hook/unknown_faces im Ordner config anlegen"
                			mkdir -p /config/hook/unknown_faces
                		fi
                
                		# Install for face recognition
                 		pip3 install face_recognition
                	fi
                
                	# Set hook folder permissions
                	chown -R $PUID:$PGID /config/hook
                	chmod -R 777 /config/hook
                
                	echo "Hook - Installation abgeschlossen"
                
                	# Compile opencv
                	echo "Kompilieren von opencv - das wird eine Weile dauern..."  | tee -a  ~/FinalInstall.log
                	if [ -f /config/opencv/opencv_ok ] && [ `cat /config/opencv/opencv_ok` = 'yes' ]; then
                		if [ ! -f /root/setup.py ]; then
                			if [ -x /config/opencv/opencv.sh ]; then
                				/config/opencv/opencv.sh quiet >/dev/null
                			fi
                		fi
                	else
                		if [ -f /root/opencv_compile.sh ]; then
                			chmod +x /root/opencv_compile.sh
                			/root/opencv_compile.sh >/dev/null
                		fi
                	fi
                
                	mv /root/zmeventnotification/setup.py /root/setup.py
                fi
                
                echo "Dienste starten..."  | tee -a  ~/FinalInstall.log
                service apache2 start
                if [ "$NO_START_ZM" != "1" ]; then
                	service mysql start
                
                	# Update the database if necessary
                	zmupdate.pl -nointeractive
                	zmupdate.pl -f
                
                	service zoneminder start
                else
                	echo "WARNUNG: MySql und Zoneminder nicht gestartet."
                fi
				
				
				
				
				nano /etc/zm/secrets.ini
				nano /etc/zm/zmeventnotification.ini
				
                