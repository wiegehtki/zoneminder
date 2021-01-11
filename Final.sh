#!/usr/bin/env bash

# Es wird empfohlen root als Benutzer zu verwenden
Benutzer="root"

export DEBCONF_NONINTERACTIVE_SEEN="true"
export DEBIAN_FRONTEND="noninteractive"
export CUDA_Version=10.1
export CUDA_Script=cuda_10.1.105_418.39_linux.run
export CUDA_Pfad=/usr/local/cuda-11.2
export CUDA_Download=https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
export PHP_VERS="7.2"
export OPENCV_VER=4.5.1
export OPENCV_URL=https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
export OPENCV_CONTRIB_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip
export TZ="Europe/Berlin"
export PYTHON_INCLUDE_DIRS=/usr/include/python3.6
export PYTHON_LIBRARIES=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/libpython3.6.so
export SHMEM="50%"
export MULTI_PORT_START="0"
export MULTI_PORT_END="0"


if [ "$(whoami)" != $Benutzer ]; then
        echo $(date -u) "Script muss als Benutzer $Benutzer ausgeführt werden!"
        exit 255
fi

echo $(date -u) "Test auf bestehende FinalInstall.log"
      test -f ~/FinalInstall.log && rm ~/FinalInstall.log

echo $(date -u) "FinalInstall.log anlegen"
      touch ~/FinalInstall.log


echo $(date -u) "########################################################################################################################" | tee -a  ~/FinalInstall.log
echo $(date -u) "# Zoneminder - Objekterkennung mit OpenCV, CUDA, cuDNN und YOLO auf Ubuntu 18.04 LTS                   By WIEGEHTKI.DE #" | tee -a  ~/FinalInstall.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                               #" | tee -a  ~/FinalInstall.log
echo $(date -u) "#                                                                                                                      #" | tee -a  ~/FinalInstall.log
echo $(date -u) "# V1.0.0 (Rev a), 06.01.2021                                                                                           #" | tee -a  ~/FinalInstall.log
echo $(date -u) "########################################################################################################################" | tee -a  ~/FinalInstall.log

echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "01 von 07: CUDA runterladen und samt Grafiktreiber installieren"  | tee -a  ~/FinalInstall.log
                cd ~
                wget https://developer.nvidia.com/compute/cuda/$CUDA_Version/Prod/local_installers/$CUDA_Script
                chmod +x $CUDA_Script
                ./$CUDA_Script --silent

echo $(date -u) "02 von 07: Check auf installierten Treiber"  | tee -a  ~/FinalInstall.log
                lshw -C display | tee -a  ~/FinalInstall.log

echo $(date -u) "03 von 07: CUDA Umgebung setzen"  | tee -a  ~/FinalInstall.log
                echo $CUDA_Pfad/lib64 >>  /etc/ld.so.conf
                ldconfig
                echo 'export PATH='$CUDA_Pfad'/bin:$PATH' >> ~/.bashrc
                echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
                echo 'cd ~' >> ~/.bashrc
                source ~/.bashrc
    
echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "02 von 07: Systemupdate und Apache, MySQL und PHP installieren"  | tee -a  ~/FinalInstall.log
                apt -y upgrade
                apt -y dist-upgrade

                apt -y install tasksel
                tasksel install lamp-server
     
                add-apt-repository -y ppa:iconnor/zoneminder-1.34
                apt -y update
                apt -y upgrade
                apt -y dist-upgrade

                apt -y install python3-pip cmake
                pip3 install --upgrade pip
                apt -y install libopenblas-dev liblapack-dev libblas-dev

                #Mysql
                rm /etc/mysql/my.cnf  
                cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf

                echo "default-time-zone='+01:00'" >> /etc/mysql/my.cnf
                echo "sql_mode        = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf
                systemctl restart mysql

echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "03 von 07: Apache konfigurieren, SSL-Zertifikate generieren und Zoneminder installieren"  | tee -a  ~/FinalInstall.log
                apt -y install zoneminder
                sudo apt -y install ntp ntp-doc
                apt -y install ssmtp mailutils net-tools wget sudo make
                apt -y install php$PHP_VERS php$PHP_VERS-fpm libapache2-mod-php$PHP_VERS php$PHP_VERS-mysql php$PHP_VERS-gd
                apt -y install libcrypt-mysql-perl libyaml-perl libjson-perl libavutil-dev ffmpeg && \
                apt -y install --no-install-recommends libvlc-dev libvlccore-dev vlc

                mysql -uroot --skip-password < /usr/share/zoneminder/db/zm_create.sql
                mysql -uroot --skip-password -e "grant lock tables,alter,drop,select,insert,update,delete,create,index,alter routine,create routine, trigger,execute on zm.* to 'zmuser'@localhost identified by 'zmpass';"

                 /etc/zm/zm.conf
                chown root:www-data /etc/zm/zm.conf
                chown -R www-data:www-data /usr/share/zoneminder/

                a2enmod cgi
                a2enmod rewrite
                a2enconf zoneminder
                a2enmod expires
                a2enmod headers

                if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
                         echo "Setzen der Zeitzone auf: $TZ"
                         echo $TZ > /etc/timezone
                         ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
                         dpkg-reconfigure tzdata -f noninteractive
                         echo "Datum: `date`"
                fi
                
                sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/cli/php.ini
                sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/apache2/php.ini
                sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/fpm/php.ini

                mkdir /etc/apache2/ssl/
                mkdir /etc/zm/apache2/
                mkdir /etc/zm/apache2/ssl/
                mv /root/zoneminder/apache/default-ssl.conf    /etc/apache2/sites-enabled/default-ssl.conf
                cp /etc/apache2/ports.conf                     /etc/apache2/ports.conf.default
                cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default

                echo "localhost" >> /etc/apache2/ssl/ServerName
                export SERVER=`cat /etc/apache2/ssl/ServerName`
                # Test wegen doppelten Einträgen UW 9.1.2021
				(echo "ServerName" $SERVER && cat /etc/apache2/apache2.conf) > /etc/apache2/apache2.conf.old && mv  /etc/apache2/apache2.conf.old /etc/apache2/apache2.conf

                if [[ -f /etc/apache2/ssl/cert.key && -f /etc/apache2/ssl/cert.crt ]]; then
                    echo "Bestehendes Zertifikat gefunden in \"/etc/apache2/ssl/cert.key\""  | tee -a  ~/FinalInstall.log
                else
                    echo "Es werden self-signed keys in /etc/apache2/ssl/ generiert, bitte mit den eigenen Zertifikaten bei Bedarf ersetzen"  | tee -a  ~/FinalInstall.log
                    mkdir -p /config/keys
                    dd if=/dev/urandom of=~/.rnd bs=256 count=1
                    chmod 600 ~/.rnd
                    openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /etc/apache2/ssl/cert.crt -keyout /etc/apache2/ssl/cert.key -subj "/C=DE/ST=HE/L=Frankfurt/O=Zoneminder/OU=Zoneminder/CN=localhost"
                fi

                #chown root:root /config/keys
                chmod 777 /etc/apache2/ssl
                a2enmod proxy_fcgi setenvif
                a2enconf php7.2-fpm
                systemctl reload apache2
                adduser www-data video
                /etc/php/$PHP_VERS/mods-available/apcu.ini
                echo "extension=mcrypt.so" > /etc/php/$PHP_VERS/mods-available/mcrypt.ini
                
                systemctl enable zoneminder
                systemctl start zoneminder


echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "04 von 07: zmeventnotification installieren"  | tee -a  ~/FinalInstall.log
                #python3 -m pip install numpy -I
                python3 -m pip  install numpy scipy matplotlib ipython pandas sympy nose cython
                python3 -m pip  install future

                cp -r ~/zoneminder/zmeventnotification/EventServer.zip ~/.
                unzip EventServer
                cd ~/EventServer
                chmod -R +x *
                ./install.sh --install-hook --install-es --no-install-config --no-interactive
                cd ~
                cp EventServer/zmeventnotification.ini /etc/zm/. -r
                chmod +x /var/lib/zmeventnotification/bin/*


                yes | perl -MCPAN -e "install Crypt::MySQL"
                yes | perl -MCPAN -e "install Config::IniFiles"
                yes | perl -MCPAN -e "install Crypt::Eksblowfish::Bcrypt"

                apt -y install libyaml-perl
                apt -y install make
                yes | perl -MCPAN -e "install Net::WebSocket::Server"

                apt -y install libjson-perl
                yes | perl -MCPAN -e "install LWP::Protocol::https"
                yes | perl -MCPAN -e "install Net::MQTT::Simple"

                
echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "05 von 07: Gesichtserkennung und cuDNN installieren"  | tee -a  ~/FinalInstall.log
                 
                # Face recognition
                #sudo -H pip3 uninstall dlib
                #sudo -H pip3 uninstall face-recognition
                apt -y install libopenblas-dev liblapack-dev libblas-dev # this is the important part
                cd ~/zoneminder/dlib
                #rm ~/zoneminder/dlib/build/* -rf
                python ./setup.py install 
                #wget http://dlib.net/files/dlib-19.19.tar.bz2
                #tar xvf dlib-19.19.tar.bz2
                #cd dlib-19.19/
                #mkdir build
                #cd build
                #cmake ..
                #cmake --build . --config Release
                #sudo make install
                #sudo ldconfig
                #python3 -m pip install dlib --verbose --no-cache-dir # make sure it finds openblas
                python3 -m pip install face_recognition
                rm /usr/bin/python
                ln -sf python3.6 /usr/bin/python

                #CUDNN installieren
                # Download
                cd ~
                tar -xzvf cudnn-10.1-linux-x64-v8.0.5.39.tgz
                sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
                sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
                sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "06 von 07: Gesichtserkennung und cuDNN installieren"  | tee -a  ~/FinalInstall.log
 
                #opencv compilieren
                apt -y install python-dev python3-dev
                apt -y install python-pip
                python2 -m pip  install numpy

                cd ~
                wget  -O opencv.zip $OPENCV_URL
                wget  -O opencv_contrib.zip $OPENCV_CONTRIB_URL
                unzip opencv.zip
                unzip opencv_contrib.zip
                mv $(ls -d opencv-*) opencv
                mv opencv_contrib-$OPENCV_VER opencv_contrib
                #rm *.zip

                #logger "Compiling opencv..." -tEventServer

                cd ~/opencv
                rm -rf build
                mkdir build
                cd build

                #Wichtig: Je nach Karte wählen - CUDA_ARCH_BIN = https://en.wikipedia.org/wiki/CUDA 
                cmake -D CMAKE_BUILD_TYPE=RELEASE \
                      -D CMAKE_INSTALL_PREFIX=/usr/local \
                      -D INSTALL_PYTHON_EXAMPLES=OFF \
                      -D INSTALL_C_EXAMPLES=OFF \
                      -D OPENCV_ENABLE_NONFREE=ON \
                      -D WITH_CUDA=ON \
                      -D WITH_CUDNN=ON \
                      -D OPENCV_DNN_CUDA=ON \
                      -D ENABLE_FAST_MATH=1 \
                      -D CUDA_FAST_MATH=1 \
                      -D CUDA_ARCH_BIN=6.1 \
                      -D CUDA_ARCH_PTX=6.1 \
                      -D WITH_CUBLAS=1 \
                      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
                      -D HAVE_opencv_python3=ON \
                      -D PYTHON_EXECUTABLE=/usr/bin/python3 \
                      -D PYTHON2_EXECUTABLE=/usr/bin/python2 \
                      -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
                      -D PYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
                      -D PYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
                      -D BUILD_EXAMPLES=OFF ..

                make -j$(nproc)


                #logger "Installing opencv..." -tEventServer
                make install

                echo "Test auf CUDA enabled Devices, muss größer 0 sein:" | tee -a  ~/FinalInstall.log
                echo "import cv2" | tee -a  ~/FinalInstall.log
                echo "count = cv2.cuda.getCudaEnabledDeviceCount()" | tee -a  ~/FinalInstall.log
                echo "print(count)" | tee -a  ~/FinalInstall.log

                #/usr/local/lib/python3.6/dist-packages/cv2
                
                chown root:www-data /etc/zm/conf.d/*.conf
                chmod 640 /etc/zm/conf.d/*.conf

echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
echo $(date -u) "07 von 07: Bugfixes kopieren und Ende"  | tee -a  ~/FinalInstall.log
                cp -r ~/zoneminder/Bugfixes/face_train.py /usr/local/lib/python3.6/dist-packages/pyzm/ml/face_train.py
                echo "Installation beendet, bitte Rechner neu starten (reboot)"
                echo ""

                cp -r ~/zoneminder/Anzupassen/. /etc/zm/.
                # Fix memory issue
                echo "Setzen shared memory auf :" $SHMEM "von `awk '/MemTotal/ {print $2}' /proc/meminfo` bytes"  | tee -a  ~/FinalInstall.log
                umount /dev/shm
                mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${SHMEM} tmpfs /dev/shm

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
                
                chown -R root:www-data /etc/apache2/ssl/*
                a2enmod ssl
                systemctl restart apache2        

#Test:
#https://zm.wiegehtki.de/zm/api/host/getVersion.json
#https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=snapshot
#https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=alarm

#/var/lib/zmeventnotification/known_faces
#sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
#sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid 1 --monitorid 1 --debug
#chown -R www-data:www-data /var/lib/zmeventnotification/known_faces
#echo "zm.wiegehtki.de" >> /etc/hosts

#rtmp://192.168.100.164/bcs/channel0_main.bcs?channel=0&stream=0&user=admin&password=<Dein Passwort>



