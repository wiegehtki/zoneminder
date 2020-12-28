#!/usr/bin/env bash

# Es wird empfohlen root als Benutzer zu verwenden 
Benutzer="root"
CUDA_Version=11.2.0
CUDA_Script=cuda_11.2.0_460.27.04_linux.run
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
echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "01 von 30: CUDA runterladen und samt Grafiktreiber installieren"  | tee -a  ~/FinalInstall.log
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
echo $(date -u) "03 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log
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
echo $(date -u) "04 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log

                #mkdir /mnt/cache/appdata/Zoneminder

                cd ~
                #git clone https://github.com/dlandon/zoneminder.master-docker.git
                cp -r zoneminder/init/. /etc/my_init.d/.                                
                cp -r zoneminder/defaults/. /root/.

                add-apt-repository -y ppa:iconnor/zoneminder-$ZM_VERS 
	            LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php 
	            add-apt-repository ppa:jonathonf/ffmpeg-4 
	            apt-get update 
	            apt-get -y upgrade -o Dpkg::Options::="--force-confold" 
	            apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" 
	            apt-get -y install apache2 mariadb-server 
	            apt-get -y install ssmtp mailutils net-tools wget sudo make 
	            apt-get -y install php$PHP_VERS php$PHP_VERS-fpm libapache2-mod-php$PHP_VERS php$PHP_VERS-mysql php$PHP_VERS-gd && \
	            apt-get -y install libcrypt-mysql-perl libyaml-perl libjson-perl libavutil-dev ffmpeg && \
	            apt-get -y install --no-install-recommends libvlc-dev libvlccore-dev vlc && \
	            apt-get -y install zoneminder

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "05 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log

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
echo $(date -u) "05 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log

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
echo $(date -u) "05 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log
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
echo $(date -u) "05 von 30: Umgebungsvariablen für die Zoneminder - Installation setzen"  | tee -a  ~/FinalInstall.log
                apt -y remove make
                apt -y clean 
                apt -y autoremove 
                rm -rf /tmp/* /var/tmp/* 
                chmod +x /etc/my_init.d/*.sh

                mkdir /config
                mkdir /var/cache/zoneminder
	
	
	