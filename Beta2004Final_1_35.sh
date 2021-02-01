#!/usr/bin/env bash
                # Es wird empfohlen root als Benutzer zu verwenden
                Benutzer="root" 
                
                export PHP_VERS="7.4"
                export OPENCV_VER="4.5.1"
                export PYTHON_VER="3.8"
               
                #export CUDA_Download=https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
                #export CUDA_Script=cuda_10.1.105_418.39_linux.run
                export CUDA_Download=https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run
                export CUDA_Script=cuda_11.1.1_455.32.00_linux.run
                #export CUDA_Download=https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
                #export CUDA_Script=cuda_11.2.0_460.27.04_linux.run
                
                export CUDA_COMPUTE_CAPABILITY=6.1
                export CUDA_SEARCH_PATH="/usr/local/cuda-11.1/lib64"
                export CUDA_EXAMPLES_PATH="NVIDIA_CUDA-11.1_Samples"
                export CUDNN_VERSION_1804="cudnn-10.1-linux-x64-v8.0.5.39.tgz"
                export CUDNN_VERSION_2004="cudnn-11.1-linux-x64-v8.0.5.39.tgz"
                export DEBCONF_NONINTERACTIVE_SEEN="true"
                                
                export DEBIAN_FRONTEND="noninteractive"
                export CUDA_PFAD_BASHRC="/usr/local/cuda-11.1/bin"
                export CUDA_PFAD="/usr/local/cuda-11.1"
                export OPENCV_VER=4.5.1
                export OPENCV_URL=https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
                export OPENCV_CONTRIB_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip
                export TZ="Europe/Berlin"
                export PYTHON_INCLUDE_DIRS=/usr/include/python$PYTHON_VER
                export PYTHON_LIBRARIES=/usr/lib/python$PYTHON_VER/config-$PYTHON_VER-x86_64-linux-gnu/libpython$PYTHON_VER.so
                export SHMEM="50%"
                export MULTI_PORT_START="0"
                export MULTI_PORT_END="0"
                export LINUX_VERSION_NAME=`lsb_release -sr`
                                 
                #Vorbelegung CompilerFlags und Warnungen zu unterdr√ºcken die durch automatisch generierten Code schnell mal entstehen k√∂nnen und keine wirkliche Relevanz haben
                export CFLAGS=$CFLAGS" -w"
                export CPPFLAGS=$CPPFLAGS" -w"
                export CXXFLAGS=$CXXFLAGS" -w"
                
                
                if [ "$(whoami)" != $Benutzer ]; then
                       echo $(date -u) "Script muss als Benutzer $Benutzer ausgef¸hrt werden!"
                       exit 255
                fi
                
                echo $(date -u) "Test auf bestehende FinalInstall.log"
                     test -f ~/FinalInstall.log && rm ~/FinalInstall.log
                
                echo $(date -u) "FinalInstall.log anlegen"
                     touch ~/FinalInstall.log
                 
                 
                if lshw -C display | grep -q 'nouveau'; then
                      echo $(date -u) "NOUVEAU - Grafiktreiber muss de-aktiviert sein! Bitte Initial-Script pr¸fen bzw. vorher laufen lassen."
                      exit 255
                fi

                if [[ ${LINUX_VERSION_NAME} == "18.04" ]]; then
                   export UBUNTU_VER="18.04"
                else
                   if [[ ${LINUX_VERSION_NAME} == "20.04" ]]; then
                       export UBUNTU_VER="20.04"
                   else
                       echo " "
                       echo "Keine g¸ltige Distribution, Installer wird beendet"
                       exit 255
                   fi
                fi
                 

echo $(date -u) "########################################################################################################################" | tee -a  ~/FinalInstall.log
echo $(date -u) "# Zoneminder - Objekterkennung mit OpenCV, CUDA, cuDNN und YOLO auf Ubuntu 18.04 LTS und 20.04 LTS     By WIEGEHTKI.DE #" | tee -a  ~/FinalInstall.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gew‰hr und nur auf Testsystemen anzuwenden                                               #" | tee -a  ~/FinalInstall.log
echo $(date -u) "#                                                                                                                      #" | tee -a  ~/FinalInstall.log
echo $(date -u) "# V2.0.0 (Rev a), 30.01.2021                                                                                           #" | tee -a  ~/FinalInstall.log
echo $(date -u) "########################################################################################################################" | tee -a  ~/FinalInstall.log
echo $(date -u) "Pakete aktualisieren"  | tee -a  ~/FinalInstall.log                
                UpdatePackages() {
                    apt-get -y update
                    apt-get -y dist-upgrade
                }
echo $(date -u) "........................................................................................................................" | tee -a  ~/FinalInstall.log
                InstallCuda() {
                    echo $(date -u) "CUDA - Download und Installation inklusive Grafiktreiber"  | tee -a  ~/FinalInstall.log
                    cd ~
                    wget $CUDA_Download 
                    if [ -f ~/$CUDA_Script ]; then
                        chmod +x $CUDA_Script
                        ./$CUDA_Script --silent
                        lshw -C display | tee -a  ~/FinalInstall.log
                        #Pfade setzen
                        echo $CUDA_SEARCH_PATH >> /etc/ld.so.conf
                        ldconfig
                        echo 'export PATH='$CUDA_SEARCH_PATH':'$PATH >> ~/.bashrc
                        export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} >> ~/.bashrc
                        export PATH=/usr/local/cuda/bin${PATH:+:${PATH}} >> ~/.bashrc
                        echo 'cd ~' >> ~/.bashrc
                        source ~/.bashrc
                        apt-get -y install nvidia-cuda-toolkit
                        echo $(date -u) "Kompilieren der CUDA - Beispiele um DeviceQuery zu ermˆglichen"  | tee -a  ~/FinalInstall.log
                                    
                        cd ~/$CUDA_EXAMPLES_PATH
                        make -j$(nproc) 
                        cd ~
                        if [ -f ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery ];  then 
                            ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery | tee -a  ~/FinalInstall.log
                            ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery | grep "CUDA Capability Major/Minor version number:" >  ~/ComputeCapability.CUDA
                            for i in ` sed s'/=/ /g' ~/ComputeCapability.CUDA | awk '{print $6}' `
                                do  
                                export CUDA_COMPUTE_CAPABILITY=$i
                                declare var="$i"
                            done  
                        else
                            echo $(date -u) "Fehler beim  Ausf¸hren von deviceQuery! Standardwert f¸r CUDA_COMPUTE_CAPABILITY wird beibehalten!"  | tee -a  ~/FinalInstall.log
                        fi
                        # PATH includes /usr/local/cuda-11.2/bin
                        # LD_LIBRARY_PATH includes /usr/local/cuda-11.2/lib64, or, add /usr/local/cuda-11.2/lib64 to /etc/ld.so.conf and run ldconfig as root
                        #return 0
                    else
                       echo " "
                       echo $CUDA_Script "konnte nicht herunter geladen werden, Abbruch..." | tee -a  ~/FinalInstall.log
                       #return 1
                    fi
                }
                InstallcuDNN() {
                    echo $(date -u) "cuDNN - Installation"  | tee -a  ~/FinalInstall.log
                    local cuDNNFile
                    cd ~
                    if [ -f ~/$CUDNN_VERSION_1804 ] && [ "$UBUNTU_VER" = "18.04" ]; then
                          cuDNNFile=$CUDNN_VERSION_1804
                    else
                        if [ -f ~/$CUDNN_VERSION_2004 ] && [ "$UBUNTU_VER" = "20.04" ]; then
                            cuDNNFile=$CUDNN_VERSION_2004
                        else
                            echo " "
                            echo "cuDNN - Datei konnte nicht gefunden werden, Abbruch..." | tee -a  ~/FinalInstall.log
                            return 1
                        fi
                    fi
                    tar -xzvf $cuDNNFile
                    cp cuda/include/cudnn*.h /usr/local/cuda/include
                    cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
                    chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
                    cd /usr/local/cuda/lib64
                    if [ -f libcudnn.so ];   then rm libcudnn.so;   fi 
                    if [ -f libcudnn.so.8 ]; then rm libcudnn.so.8; fi 
                    ln libcudnn.so.8.0.5 libcudnn.so.8
                    ln libcudnn.so.8 libcudnn.so
                    
                    cd  /usr/local/cuda-11.2/targets/x86_64-linux/lib
                    if [ -f libcudnn_adv_infer.so ];   then rm libcudnn_adv_infer.so;   fi 
                    if [ -f libcudnn_ops_train.so ];   then rm libcudnn_ops_train.so;   fi 
                    if [ -f libcudnn_cnn_train.so ];   then rm libcudnn_cnn_train.so;   fi 
                    if [ -f libcudnn_cnn_infer.so ];   then rm libcudnn_cnn_infer.so;   fi 
                    if [ -f libcudnn_adv_train.so ];   then rm libcudnn_adv_train.so;   fi 
                    if [ -f libcudnn_ops_infer.so ];   then rm libcudnn_ops_infer.so;   fi 
                    if [ -f libcudnn_adv_infer.so.8 ]; then rm libcudnn_adv_infer.so.8; fi 
                    if [ -f libcudnn_ops_train.so.8 ]; then rm libcudnn_ops_train.so.8; fi 
                    if [ -f libcudnn_cnn_train.so.8 ]; then rm libcudnn_cnn_train.so.8; fi 
                    if [ -f libcudnn_cnn_infer.so.8 ]; then rm libcudnn_cnn_infer.so.8; fi 
                    if [ -f libcudnn_adv_train.so.8 ]; then rm libcudnn_adv_train.so.8; fi 
                    if [ -f libcudnn_ops_infer.so.8 ]; then rm libcudnn_ops_infer.so.8; fi 
                    
                    ln libcudnn_adv_infer.so.8.0.5 libcudnn_adv_infer.so.8
                    ln libcudnn_ops_train.so.8.0.5 libcudnn_ops_train.so.8
                    ln libcudnn_cnn_train.so.8.0.5 libcudnn_cnn_train.so.8
                    ln libcudnn_cnn_infer.so.8.0.5 libcudnn_cnn_infer.so.8
                    ln libcudnn_adv_train.so.8.0.5 libcudnn_adv_train.so.8
                    ln libcudnn_ops_infer.so.8.0.5 libcudnn_ops_infer.so.8
                    ln libcudnn_adv_infer.so.8 libcudnn_adv_infer.so
                    ln libcudnn_ops_train.so.8 libcudnn_ops_train.so
                    ln libcudnn_cnn_train.so.8 libcudnn_cnn_train.so
                    ln libcudnn_cnn_infer.so.8 libcudnn_cnn_infer.so
                    ln libcudnn_adv_train.so.8 libcudnn_adv_train.so
                    ln libcudnn_ops_infer.so.8 libcudnn_ops_infer.so
                    ldconfig  
                    return 0                    
                }
                SetUpMySQL() {
                    echo $(date -u) "MySQL - Setup"  | tee -a  ~/FinalInstall.log
                    if [ $# -eq 0 ]; then
                        rm /etc/mysql/my.cnf  
                        cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf
                        
                        echo "default-time-zone='+01:00'" >> /etc/mysql/my.cnf
                        echo "sql_mode        = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf
                        mysql_tzinfo_to_sql /usr/share/zoneinfo/Europe | sudo mysql -u root mysql
                        mysql -e "SET GLOBAL time_zone = 'Berlin';"
                        systemctl restart mysql
                    else 
                        mysql -uroot --skip-password < /usr/share/zoneminder/db/zm_create.sql
                        mysql -uroot --skip-password < ~/database/Settings.sql
                        mysqladmin -uroot --skip-password reload
                    fi 
                }
                SetUpPHP() {
                    echo $(date -u) "PHP "$PHP_VERS" - Setup"  | tee -a  ~/FinalInstall.log
                    apt -y install php$PHP_VERS php$PHP_VERS-fpm libapache2-mod-php$PHP_VERS php$PHP_VERS-mysql php$PHP_VERS-gd
                    if [ -f /etc/php/$PHP_VERS/cli/php.ini ]; then
                        sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/cli/php.ini
                    fi
                    if [ -f /etc/php/$PHP_VERS/apache2/php.ini ]; then
                        sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/apache2/php.ini
                    fi
                    if [ -f /etc/php/$PHP_VERS/fpm/php.ini ]; then
                        sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/$PHP_VERS/fpm/php.ini
                    fi
                    echo "extension=apcu.so" > /etc/php/$PHP_VERS/mods-available/apcu.ini
                    echo "extension=mcrypt.so" > /etc/php/$PHP_VERS/mods-available/mcrypt.ini
                }
                AccessRightsZoneminder() {
                    echo $(date -u) "Zoneminder - Zugriffsrechte setzen"  | tee -a  ~/FinalInstall.log
                    chown root:www-data /etc/zm/zm.conf
                    chown -R www-data:www-data /usr/share/zoneminder/
                    chown root:www-data /etc/zm/conf.d/*.conf
                    chmod 640 /etc/zm/conf.d/*.conf
                    chown -R  www-data:www-data /etc/apache2/ssl
                }
               
                SetUpApache2() {
                    echo $(date -u) "Apache2 - Setup"  | tee -a  ~/FinalInstall.log
                    a2enmod cgi
                    a2enmod rewrite
                    a2enconf zoneminder
                    a2enmod expires
                    a2enmod headers
                    mkdir /etc/apache2/ssl/
                    mkdir /etc/zm/apache2/
                    mkdir /etc/zm/apache2/ssl/
                    mv /root/zoneminder/apache/default-ssl.conf    /etc/apache2/sites-enabled/default-ssl.conf
                    cp /etc/apache2/ports.conf                     /etc/apache2/ports.conf.default
                    cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default
                    
                    echo "localhost" >> /etc/apache2/ssl/ServerName
                    export SERVER=`cat /etc/apache2/ssl/ServerName`
                    # Test wegen doppelten Eintr√§gen UW 9.1.2021
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
                    chmod 777 /etc/apache2/ssl
                    a2enmod proxy_fcgi setenvif
                    a2enconf php$PHP_VERS-fpm
                    adduser www-data video
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
                    systemctl reload apache2
                }
                InstallZoneminder() {
                    echo $(date -u) "Zoneminder - Installation & Setup"  | tee -a  ~/FinalInstall.log
                    add-apt-repository -y ppa:iconnor/zoneminder-master
                    apt-get -y install libcrypt-mysql-perl \
                                       libyaml-perl \
                                       libjson-perl 
                    apt-get -y install zoneminder 
                    apt-get -y install libavutil-dev && \
                    apt-get -y install --no-install-recommends libvlc-dev libvlccore-dev vlc
                    apt-get -y install libavcodec-dev \
                                       libavformat-dev \
                                       libswscale-dev \
                                       openexr \
                                       libopenexr-dev 
                    
                    UpdatePackages
                    #pip3 install --upgrade pip
                    SetUpMySQL
                    SetUpMySQL /usr/share/zoneminder/db/zm_create.sql
                    AccessRightsZoneminder
                    SetUpApache2
                    cp ~/zoneminder/Anzupassen/. /etc/zm/. -r
                    systemctl enable zoneminder
                    systemctl start zoneminder
                }
                #EventServer installieren
                InstallEventerver() {
                    echo $(date -u) "EventServer - Setup"  | tee -a  ~/FinalInstall.log
                    apt-get -y install python3-numpy
                    python3 -m pip  install scipy matplotlib ipython pandas sympy nose cython
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
                    
                    # Fix memory issue
                    echo "Setzen shared memory auf :" $SHMEM "von `awk '/MemTotal/ {print $2}' /proc/meminfo` bytes"  | tee -a  ~/FinalInstall.log
                    umount /dev/shm
                    mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${SHMEM} tmpfs /dev/shm
                 
                 
                 chown -R www-data:www-data /etc/apache2/ssl/*
                 a2enmod ssl
                 systemctl restart apache2  
                }
                #Apache, MySQL, PHP 
                InstallFaceRecognition() {
                    echo $(date -u) "Gesichtserkennung - Setup"  | tee -a  ~/FinalInstall.log
                    if python -c 'import pkgutil; exit(not pkgutil.find_loader("dlib"))'; then
                       sudo -H pip3 uninstall dlib
                    fi
                    if python -c 'import pkgutil; exit(not pkgutil.find_loader("face-recognition"))'; then
                       sudo -H pip3 uninstall face-recognition
                    fi
                    cd ~/zoneminder/dlib
                    python3 ./setup.py install 
                    python3 -m pip install face_recognition
                    cp -r ~/zoneminder/Bugfixes/face_train.py /usr/local/lib/python$PYTHON_VER/dist-packages/pyzm/ml/face_train.py
                }                        

                InstallLAMP() {
                    echo $(date -u) "LAMP - Setup"  | tee -a  ~/FinalInstall.log
                    apt-get -y install tasksel
                    tasksel install lamp-server
                    #add-apt-repository -y ppa:iconnor/zoneminder-1.34
                }                        
                InstallOpenCV(){
                    echo $(date -u)  "OpenCV kompilieren mit Compute Capability " $CUDA_COMPUTE_CAPABILITY    | tee -a  ~/FinalInstall.log
                    apt-get -y install python-pip
                    #python2 -m pip  install numpy
                    cd ~
                    wget  -O opencv.zip $OPENCV_URL
                    wget  -O opencv_contrib.zip $OPENCV_CONTRIB_URL
                    unzip opencv.zip
                    unzip opencv_contrib.zip
                    mv $(ls -d opencv-*) opencv
                    mv opencv_contrib-$OPENCV_VER opencv_contrib
                    cd ~/opencv
                    rm -rf build
                    mkdir build
                    cd build
                    export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
                    export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                    #Wichtig: Je nach Karte anpassen - CUDA_ARCH_BIN = https://en.wikipedia.org/wiki/CUDA 
                    
                    cmake -D CMAKE_BUILD_TYPE=RELEASE \
                          -D CMAKE_INSTALL_PREFIX=/usr/local \
                          -D INSTALL_PYTHON_EXAMPLES=OFF \
                          -D INSTALL_C_EXAMPLES=OFF \
                          -D OPENCV_ENABLE_NONFREE=ON \
                          -D OPENCV_GENERATE_PKGCONFIG=ON \
                          -D WITH_CUDA=ON \
                          -D WITH_CUDNN=ON \
                          -D OPENCV_DNN_CUDA=ON \
                          -D ENABLE_FAST_MATH=1 \
                          -D CUDA_FAST_MATH=1 \
                          -D CUDA_ARCH_BIN=$CUDA_COMPUTE_CAPABILITY \
                          -D CUDA_ARCH_PTX="" \
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
                    pkg-config --cflags --libs opencv4
                    pkg-config --modversion opencv4
                    
                    echo "Test auf CUDA enabled Devices, muss grˆsser 0 sein:" | tee -a  ~/FinalInstall.log
                    echo "import cv2" | tee -a  ~/FinalInstall.log
                    echo "count = cv2.cuda.getCudaEnabledDeviceCount()" | tee -a  ~/FinalInstall.log
                    echo "print(count)" | tee -a  ~/FinalInstall.log
                
                }
 
                installLibs(){
                echo "Notwendige Pakete installieren"
                sudo apt-get update
                sudo apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
                     libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
                     libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev libopus-dev
                }
                 
                #Install nvidia SDK
                installSDK(){
                    echo "Installieren NVIDIA Codecs."
                    cd ~/ffmpeg_sources
                    cd ~/ffmpeg_sources
                    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
                    cd nv-codec-headers
                    make -j$(nproc)
                    sudo make install
                }
                
                #nasm
                compileNasm(){
                    echo "Kompilieren von nasm"
                    cd ~/ffmpeg_sources
                    wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz
                    tar xzvf nasm-2.15.05.tar.gz
                    cd nasm-2.15.05
                    ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
                    make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) distclean
                }
                
                #libx264
                compileLibX264(){
                    echo "Kompilieren von libx264"
                    cd ~/ffmpeg_sources
                    wget https://download.videolan.org/pub/x264/snapshots/x264-snapshot-20191217-2245-stable.tar.bz2 
                    tar xjvf x264-snapshot-20191217-2245-stable.tar.bz2
                    cd x264-snapshot-20191217-2245-stable
                    PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
                    PATH="$HOME/bin:$PATH" make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) distclean
                }
                
                #libfdk-acc
                compileLibfdkcc(){
                    echo "Kompilieren von libfdk-cc"
                    sudo apt-get install unzip
                    cd ~/ffmpeg_sources
                    wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
                    unzip fdk-aac.zip
                    cd mstorsjo-fdk-aac*
                    autoreconf -fiv
                    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
                    make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) distclean
                }
                
                #libmp3lame
                compileLibMP3Lame(){
                    echo "Kompilieren von libmp3lame"
                    sudo apt-get install nasm
                    cd ~/ffmpeg_sources
                    wget http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
                    tar xzvf lame-3.100.tar.gz
                    cd lame-3.100
                    ./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
                    make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) distclean
                }
                
                #libopus
                compileLibOpus(){
                    echo "Kompilieren von libopus"
                    cd ~/ffmpeg_sources
                    wget http://downloads.xiph.org/releases/opus/opus-1.3.1.tar.gz
                    tar xzvf opus-1.3.1.tar.gz
                    cd opus-1.3.1
                    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
                    make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) distclean
                }
    
                #libx265
                compileLibX265(){
                    echo "Kompilieren von libx265"               
                    cd ~
                    git clone https://bitbucket.org/multicoreware/x265_git
                    cd x265_git/build/linux
                    cmake -G "Unix Makefiles" ../../source
                    make install
                }
    
                #libvpx
                    compileLibPvx(){
                    echo "Kompilieren von libvpx"
                    cd ~/ffmpeg_sources
                    git clone https://chromium.googlesource.com/webm/libvpx
                    cd libvpx
                    PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
                    --enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-better-hw-compatibility --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only \
                    --cpu=native --as=nasm
                    PATH="$HOME/bin:$PATH" make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) clean
                }
                
                #ffmpeg
                compileFfmpeg(){
                    echo "Kompilieren von ffmpeg"
                    cd ~/ffmpeg_sources
                    git clone https://github.com/FFmpeg/FFmpeg -b master
                    cd FFmpeg
                    apt-get -y install build-essential pkg-config checkinstall git libfaac-dev libgpac-dev ladspa-sdk-dev libunistring-dev libbz2-dev \
                    libjack-jackd2-dev libmp3lame-dev libsdl2-dev libopencore-amrnb-dev libopencore-amrwb-dev libvpx-dev libx264-dev libx265-dev libxvidcore-dev libopenal-dev libopus-dev \
                    libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev \
                    libxfixes-dev texi2html yasm zlib1g-dev
                    
                    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
                        --prefix="$HOME/ffmpeg_build" \
                        --extra-cflags="-I$HOME/ffmpeg_build/include" \
                        --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
                        --bindir="$HOME/bin" \
                        --enable-cuda-nvcc \
                        --enable-cuvid \
                        --enable-libnpp \
                        --extra-cflags="-I/usr/local/cuda/include/" \
                        --extra-ldflags=-L/usr/local/cuda/lib64/ \
                        --enable-gpl \
                        --enable-libass \
                        --enable-libfdk-aac \
                        --enable-vaapi \
                        --enable-libfreetype \
                        --enable-libmp3lame \
                        --enable-libopus \
                        --enable-libtheora \
                        --enable-libvorbis \
                        --enable-libvpx \
                        --enable-libx264 \
                        --enable-libx265 \
                        --enable-nonfree \
                        --enable-nvenc \
                        --pkg-config-flags="--static"
                    
                     ./configure --pkg-config-flags="--static" --enable-nonfree --enable-gpl --enable-version3 --enable-libmp3lame --enable-libvpx --enable-libopus --enable-opencl --enable-libxcb --enable-opengl --enable-nvenc --enable-vaapi --enable-vdpau --enable-ffplay --enable-ffprobe --enable-libxvid --enable-libx264 --enable-libx265 --enable-openal --enable-cuda-nvcc --enable-cuvid --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64ble-openal --enable-cuda-nvcc --enable-cuvid
                     
                    PATH="$HOME/bin:$PATH" make -j$(nproc)
                    make -j$(nproc) install
                    make -j$(nproc) distclean
                    hash -r
               }
                #Bugfixing und Finalisierung
                BugFixes_Init() {
                python3 -m pip install protobuf==3.3.0
                python3 -m pip install numpy==1.16.5
                
                yes | perl -MCPAN -e "upgrade IO::Socket::SSL"
                cd ~
                zmupdate.pl -f
                }
                                
echo $(date -u) "Starten der Installation"  | tee -a  ~/FinalInstall.log
                if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
                   echo "Setzen der Zeitzone auf: $TZ"
                   echo $TZ > /etc/timezone
                   ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
                   dpkg-reconfigure tzdata -f noninteractive
                   echo "Datum: `date`"
                fi
                
                if InstallCuda $1;  then echo "InstallCuda ok" | tee -a  ~/FinalInstall.log; else echo "Fehler bei InstallCuda: Returnwert:" $1 | tee -a  ~/FinalInstall.log; fi
                if InstallcuDNN $1; then echo "InstallcuDNN ok" | tee -a  ~/FinalInstall.log; else echo "Fehler bei InstallcuDNN: Returnwert:" $1 | tee -a  ~/FinalInstall.log; fi
                UpdatePackages
                InstallLamp
                SetUpPHP
                InstallZoneminder
                InstallEventerver
                BugFixes_Init
                InstallFaceRecognition
                AccessRightsZoneminder
                InstallOpenCV
                BugFixes_Init
                AccessRightsZoneminder
                 
               

           #    cd ~
           #    mkdir ffmpeg_sources
           #    installLibs
               #InstallCUDASDK
           #    installSDK
           #    compileNasm
           #    compileLibX264
           #    compileLibX265
           #    compileLibfdkcc
           #    compileLibMP3Lame
           #    compileLibOpus
           #    compileLibPvx
               #The process
           #    export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
           #    export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
         #      compileFfmpeg
               #Bei 18.04?
               #cp ~/bin/ffmpeg  /usr/bin/ -r
            #   echo "Libraries und ffmpeg kompiliert!"
               
                
                #rm *.zip

                #logger "Compiling opencv..." -tEventServer


                #Test:
                #https://zm.wiegehtki.de/zm/api/host/getVersion.json
                #https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=snapshot
                #https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=alarm

                ##### Verzeichnis f√ºr Gesichtstraining
                #/var/lib/zmeventnotification/known_faces

                #sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
                #sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid 1 --monitorid 1 --debug
                #chown -R www-data:www-data /var/lib/zmeventnotification/known_faces
                #echo "<DEINE_IP>  <DEINE_DOMAIN>" >> /etc/hosts

                ##### Link f√ºr Reolink Kameras, getestet mit RL410 #####
                #rtmp://<KAMERA_IP>/bcs/channel0_main.bcs?channel=0&stream=0&user=admin&password=<Dein Passwort>




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



