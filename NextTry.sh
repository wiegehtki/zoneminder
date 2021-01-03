#!/usr/bin/env bash

# Es wird empfohlen root als Benutzer zu verwenden
Benutzer="root"

CUDA_Version=10.1
CUDA_Script=cuda_10.1.105_418.39_linux.run
CUDA_Pfad=/usr/local/cuda-11.2
CUDA_Download=https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
PHP_VERS=7.2
OPENCV_VER=4.5.1
OPENCV_URL=https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
OPENCV_CONTRIB_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip
TZ="Europe/Berlin"

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
echo $(date -u) "# Zoneminder - Objekterkennung mit OpenCV und YOLO. By WIEGEHTKI.DE                     #" | tee -a  ~/Installation.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                #" | tee -a  ~/Installation.log
echo $(date -u) "#                                           #" | tee -a  ~/Installation.log
echo $(date -u) "# V0.0.9 (Rev a), 28.12.2020                                      #" | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "01 von 30: CUDA runterladen und samt Grafiktreiber installieren"  | tee -a  ~/FinalInstall.log
                cd ~
                wget https://developer.nvidia.com/compute/cuda/$CUDA_Version/Prod/local_installers/$CUDA_Script
                chmod +x $CUDA_Script
                ./$CUDA_Script --silent

echo $(date -u) "02 von 30: Check auf installierten Treiber"  | tee -a  ~/FinalInstall.log
                lshw -C display | tee -a  ~/FinalInstall.log

echo $(date -u) "03 von 30: CUDA Umgebung setzen"  | tee -a  ~/FinalInstall.log
                echo $CUDA_Pfad/lib64 >>  /etc/ld.so.conf
                ldconfig
                echo 'export PATH='$CUDA_Pfad'/bin:$PATH' >> ~/.bashrc
                echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
                echo 'cd ~' >> ~/.bashrc
                source ~/.bashrc
    
echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "02 von 30: Systemupdate und Apache, MySQL und PHP installieren"  | tee -a  ~/FinalInstall.log
                apt -y upgrade
                apt -y dist-upgrade

                apt -y install tasksel
                tasksel install lamp-server
     
                add-apt-repository ppa:iconnor/zoneminder-1.34
                apt -y update
                apt -y upgrade
                apt -y dist-upgrade

                apt -y install python3-pip cmake
                apt -y install libopenblas-dev liblapack-dev libblas-dev

                #Mysql
                rm /etc/mysql/my.cnf  
                cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf

                echo "default-time-zone='+01:00'" >> /etc/mysql/my.cnf
                echo "sql_mode        = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf
                systemctl restart mysql

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "03 von 30: Apache konfigurieren, SSL-Zertifikate generieren und Zoneminder installieren"  | tee -a  ~/FinalInstall.log
                apt -y install zoneminder
                sudo apt -y install ntp

                mysql -uroot -p < /usr/share/zoneminder/db/zm_create.sql
                mysql -uroot -p -e "grant lock tables,alter,drop,select,insert,update,delete,create,index,alter routine,create routine, trigger,execute on zm.* to 'zmuser'@localhost identified by 'zmpass';"

                chmod 740 /etc/zm/zm.conf
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
                         dpkg-reconfigure tzdata
                         echo "Datum: `date`"
                fi
                
                sed -i "s|^date.timezone =.*$|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/cli/php.ini
                sed -i "s|^date.timezone =.*$|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/apache2/php.ini

                mkdir /etc/apache2/ssl/
                mkdir /etc/zm/apache2/
                mkdir /etc/zm/apache2/ssl/
                mv /root/zoneminder/apache/default-ssl.conf    /etc/apache2/sites-enabled/default-ssl.conf
                cp /etc/apache2/ports.conf                     /etc/apache2/ports.conf.default
                cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default

                if [[ -f /etc/apache2/ssl/cert.key && -f /etc/apache2/ssl/cert.keycert.crt ]]; then
                         echo "Bestehendes Zertifikat gefunden in \"/etc/apache2/ssl/cert.key\""
                         if [[ ! -f /etc/apache2/ssl/ServerName ]]; then
                             echo "localhost" > /etc/apache2/ssl/ServerName
                         fi
                         SERVER=`cat /etc/apache2/ssl/ServerName`
                         sed -i "/ServerName/c\ServerName $SERVER" /etc/apache2/apache2.conf
                else
                         echo "Es werden self-signed keys in /etc/apache2/ssl/ generiert, bitte mit den eigenen Zertifikaten bei Bedarf ersetzen"
                         mkdir -p /config/keys
                         echo "localhost" >> /etc/apache2/ssl/ServerName
                         openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /etc/apache2/ssl/cert.crt -keyout /etc/apache2/ssl/cert.key -subj "/C=DE/ST=HE/L=Frankfurt/O=Zoneminder/OU=Zoneminder/CN=localhost"
                fi

                chown root:root /config/keys
                chmod 777 /etc/apache2/ssl
                
                systemctl enable zoneminder
                systemctl start zoneminder

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "04 von 30: zmeventnotification installieren"  | tee -a  ~/FinalInstall.log
                pip3 install numpy scipy matplotlib ipython pandas sympy nose cython
                pip3 install future

                cp -r ~/zoneminder/zmeventnotification/EventServer.zip ~/.
                unzip EventServer
                cd ~/EventServer
                ./install.sh
                cd~

#git clone https://github.com/pliablepixels/zmeventnotification.git
#    cd zmeventnotification
#git fetch --tags
#git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

##ANpassen! Thema SHell...
                perl -MCPAN -e "install Crypt::MySQL"
                perl -MCPAN -e "install Config::IniFiles"
                perl -MCPAN -e "install Crypt::Eksblowfish::Bcrypt"

                apt -y install libyaml-perl
                apt -y install make
                perl -MCPAN -e "install Net::WebSocket::Server"

                apt -y install libjson-perl
                perl -MCPAN -e "install LWP::Protocol::https"
                perl -MCPAN -e "install Net::MQTT::Simple"



#Und in etc/hosts:
#192.168.100.245 zm.wiegehtki.de

# FIX: Opt Auth enablen und dann disablen um die DB Connections zu beruhigen

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "05 von 30: Gesichtserkennung und cuDNN installieren"  | tee -a  ~/FinalInstall.log
                 
                # Face recognition
                sudo -H pip3 uninstall dlib
                sudo -H pip3 uninstall face-recognition
                sudo apt -y install libopenblas-dev liblapack-dev libblas-dev # this is the important part
                sudo -H pip3 install dlib --verbose --no-cache-dir # make sure it finds openblas
                sudo -H pip3 install face_recognition

                #CUDNN installieren
                # Download
                tar -xzvf cudnn-10.1-linux-x64-v8.0.5.39.tgz
                sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
                sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
                sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

echo $(date -u) "....................................................................................................................................." | tee -a  ~/FinalInstall.log
echo $(date -u) "06 von 30: Gesichtserkennung und cuDNN installieren"  | tee -a  ~/FinalInstall.log
 
                #opencv compilieren
                
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
                      -D WITH_CUBLAS=1 \
                      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
                      -D HAVE_opencv_python3=ON \
                      -D PYTHON_EXECUTABLE=/usr/bin/python3 \
                      -D PYTHON2_EXECUTABLE=/usr/bin/python2 \
                      -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
                      -D BUILD_EXAMPLES=OFF ..

                make -j$(nproc)

                #logger "Installing opencv..." -tEventServer
                make install

                echo "Test auf CUDA enabled Devices, muss größer 0 sein:" | tee -a  ~/FinalInstall.log
                echo "import cv2" | tee -a  ~/FinalInstall.log
                echo "count = cv2.cuda.getCudaEnabledDeviceCount()" | tee -a  ~/FinalInstall.log
                echo "print(count)" | tee -a  ~/FinalInstall.log

                /usr/local/lib/python3.6/dist-packages/cv2
                rm /usr/bin/python
                ln -sf python3.6 /usr/bin/python

                cp -r ~/zoneminder/bugfixes/face_train.py /usr/local/lib/python3.6/dist-packages/pyzm/ml/face_train.py

                sudo chown root:www-data /etc/zm/conf.d/*.conf
                sudo chmod 640 /etc/zm/conf.d/*.conf

