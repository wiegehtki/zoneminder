#!/usr/bin/env bash
                # Es wird empfohlen root als Benutzer zu verwenden
                Benutzer="root" 
                Language="German"
                
                export ZM_VERSION="1.35" 
                #export ZM_VERSION="1.34"
                export OPENCV_VER="4.5.1"
             
                ######################### CUDA 11.1.1 - Settings #####################################################################################
                export CUDA_Download=https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run
                export CUDA_Script=cuda_11.1.1_455.32.00_linux.run
                export CUDA_PFAD_BASHRC="/usr/local/cuda-11.1/bin"
                export CUDA_PFAD="/usr/local/cuda-11.1"
                export CUDA_COMPUTE_CAPABILITY=6.1
                export CUDA_SEARCH_PATH="/usr/local/cuda-11.1/lib64"
                export CUDA_EXAMPLES_PATH="NVIDIA_CUDA-11.1_Samples"

                ######################### CUDA 10.1 - Settings #######################################################################################
                #export CUDA_Download=https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
                #export CUDA_Script=cuda_10.1.105_418.39_linux.run
                #export CUDA_PFAD_BASHRC="/usr/local/cuda-10.1/bin"
                #export CUDA_PFAD="/usr/local/cuda-10.1"
                #export CUDA_COMPUTE_CAPABILITY=6.1
                #export CUDA_SEARCH_PATH="/usr/local/cuda-10.1/lib64"
                #export CUDA_EXAMPLES_PATH="NVIDIA_CUDA-10.1_Samples"
                #export CUDNN_VERSION_1804="cudnn-10.1-linux-x64-v8.0.5.39.tgz"

                ######################## cuDNN - Settings #############################################################################################
                export CUDNN_VERSION_1804="cudnn-11.1-linux-x64-v8.0.5.39.tgz"
                export CUDNN_VERSION_2004="cudnn-11.1-linux-x64-v8.0.5.39.tgz"
                
                #export CUDA_Download=https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
                #export CUDA_Script=cuda_11.2.0_460.27.04_linux.run
                
                export OPENCV_VER=4.5.1
                export OPENCV_URL=https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
                export OPENCV_CONTRIB_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip

                if [ $Language = "German" ]; then
                    declare -r errorUser="Script muss als Benutzer: $Benutzer ausgeführt werden!"
                    declare -r errorPythonVersion="Probleme beim Auslesen der Python - Version, Abbruch..."
                    declare -r errorLinuxDistribution="Keine gültige Distribution, Installer wird beendet"
                    declare -r errorGPUDriver="NOUVEAU - Grafiktreiber muss de-aktiviert sein! Bitte Initial-Script pruefen bzw. vorher laufen lassen."
                    declare -r errorDeviceQuery="Fehler beim  Ausfuehren von deviceQuery! Standardwert fuer CUDA_COMPUTE_CAPABILITY wird beibehalten!"
                    declare -r errorcuDNN="cuDNN - Installationsdatei konnte nicht gefunden werden, Abbruch..."
                    declare -r errorDownload="konnte nicht herunter geladen werden, Abbruch..."
                    declare -r errorCUDAInstall="Fehler bei InstallCuda, Fehlernummer:"
                    declare -r errorcuDNNInstall="Fehler bei InstallCuda, Fehlernummer:"
                    declare -r errorOpenCVCUDA="CUDA - Integration in OpenCV fehlgeschlagen, Abbruch..."
                    declare -r errorLinuxDist="Keine unterstützte Linux-Distribution, Installer wird beendet, Abbruch..."
                    declare -r errorZMVersion="Keine gültige Zoneminder - Version angegeben, Abbruch..."
                    declare -r errorDetectIP="IP-Adresse kann nicht ermittelt werden, Abbruch..."
                    
                    declare -r checkGPUDriver="Nouveau - Grafiktreiber de-aktivieren"
                    declare -r checkPythonVersion="Keine unterstützte Python3 - Version gefunden, Abbruch..."
                    declare -r checkInstallationLog="Test auf bestehende Installation.log"
                    declare -r checkHW_OS="Hardware_und_Linux Check"
                    declare -r checkOpenCV="Test auf CUDA enabled Devices"
                    declare -r checkOpenCVCUDA="Abfrage auf CUDA Devices in OpenCV fehlgeschlagen, Abbruch..."
                    
                    declare -r infoStep1="...Stufe 1"
                    declare -r infoStep2="...Stufe 2"
                    declare -r infoStep3="...Stufe 3"
                    declare -r infoStep4="...Stufe 4"
                    declare -r infoStep5="...Stufe 5"
                    declare -r infoStepEnd="...Beendet"
                    
                    declare -r infoStartInstallation="Start der Installation"
                    declare -r infoEndofInstallation="Ende der Initialisierung, initialisiere einen Neustart..."
                    declare -r infoSelfSignedCertificates="Es werden self-signed keys in /etc/apache2/ssl/ generiert, bitte mit den eigenen Zertifikaten bei Bedarf ersetzen"
                    declare -r infoSelfSignedCertificateFound="Bestehendes Zertifikat gefunden in"
                    declare -r infoCompileCUDAExamples="Kompilieren der CUDA - Beispiele um DeviceQuery zu ermoeglichen"
                    declare -r infoSharedMemory="Setzen shared memory"
                    declare -r infoOpenCVCUDA="CUDA - Integration in OpenCV erfolgreich durchgeführt"
                    
                    declare -r createInstallationLog="FinalInstall.log anlegen"
                    
                    declare -r installUpdate="Pakete aktualisieren"
                    declare -r installCUDA="CUDA - Download und Installation inklusive Grafiktreiber"
                    declare -r installcuDNN="Installation cuDNN"
                    declare -r installImagehandling="Pakete für Imagehandling installieren"
                    declare -r installCodecs="Codecs installieren"
                    declare -r installNVIDIACodecs="Installieren NVIDIA Codecs."
                    declare -r installCameras="Pakete für Video und Kameras installieren"
                    declare -r installCompiler="Pakete für Compiler (allgemein) installieren"
                    declare -r installCompilerv7="Pakete für Compiler (Version 7) installieren"
                    declare -r installCompilerv6="Pakete für Compiler (Version 6) installieren"
                    declare -r installTools="Diverse Tools installieren"
                    declare -r installPython37="Python 3.7 installieren"
                    declare -r installMathPacks="Mathematische Bibliotheken installieren"
                    declare -r installGoogle="Google Open-Source Pakete installieren"
                    declare -r installDataManagement="Pakete für Datenmanagement installieren"
                    declare -r installMySQL="MySQL - Setup"
                    declare -r installPHP="PHP $PHP_VERS - Setup"
                    declare -r installZM="Zoneminder - Installation & Setup"
                    declare -r installZMAccessRights="Zoneminder - Zugriffsrechte setzen"
                    declare -r installApacheSetup="Apache2 - Setup"
                    declare -r installEventServer="EventServer - Setup" 
                    declare -r installFaceRecognition="Gesichtserkennung - Setup" 
                    declare -r installLAMP="LAMP - Setup"
                    declare -r installOpenCV="OpenCV kompilieren mit Compute Capability $CUDA_COMPUTE_CAPABILITY"
                    declare -r installLibs="Notwendige Pakete installieren"
                    declare -r installNASM="Kompilieren von nasm"
                    declare -r installx264="Kompilieren von libx264"
                    declare -r installLibfdkacc="Kompilieren von libfdk-acc"
                    declare -r installLibMP3Lame="Kompilieren von libmp3lame"
                    declare -r installLibOpus="Kompilieren von libopus"
                    declare -r installLibx265="Kompilieren von libx265"
                    declare -r installLibPvx="Kompilieren von libvpx"
                    declare -r installFFMPEG="Kompilieren von ffmpeg"
                    declare -r installBugfixes="Bug fixes einspielen"
                else
                    declare -r errorUser="Script must be executed as user: $Benutzer !"
                    declare -r errorPythonVersion="Problems reading out the Python version, abort..."
                    declare -r errorLinuxDistribution="No valid distribution, installer exits"
                    declare -r errorGPUDriver="NOUVEAU - Graphics driver must be deactivated! Please check initial script or run it first."
                    declare -r errorDeviceQuery="Error when executing deviceQuery! Default value for CUDA_COMPUTE_CAPABILITY is retained!"
                    declare -r errorcuDNN="cuDNN - Installation file could not be found, abort..."
                    declare -r errorDownload="could not be downloaded, abort..."
                    declare -r errorCUDAInstall="Error with InstallCuda, Error:"
                    declare -r errorcuDNNInstall="Error with InstallcuDNN, Error:"
                    declare -r errorOpenCVCUDA="CUDA - Integration in OpenCV failed, abort..."
                    declare -r errorLinuxDist="No supported Linux distribution, installer quits, abort..."
                    declare -r errorZMVersion="No valid Zoneminder version specified, abort..."
                    declare -r errorDetectIP="IP address cannot be determined, abort..."
                    
                    declare -r checkGPUDriver= "Nouveau - Deactivate graphics drive"
                    declare -r checkPythonVersion="No supported Python3 version found, abort..."
                    declare -r checkInstallationLog="Test for existing installation.log"
                    declare -r checkHW_OS="Hardware_and_Linux check"
                    declare -r checkOpenCV="Test for CUDA enabled Devices"
                    declare -r checkOpenCVCUDA="Query on CUDA devices in OpenCV failed, abort..."
                    
                    declare -r infoStep1="...Step 1"
                    declare -r infoStep2="...Step 2"
                    declare -r infoStep3="...Step 3"
                    declare -r infoStep4="...Step 4"
                    declare -r infoStep5="...Step 5"
                    declare -r infoStepEnd="...completed"
                    
                    declare -r infoStartInstallation="Start der Installation"
                    declare -r infoEndofInstallation="End of initialisation, initialise a restart..."
                    declare -r infoSelfSignedCertificates="Self-signed keys are generated in /etc/apache2/ssl/, please replace with your own certificates if necessary."
                    declare -r infoSelfSignedCertificateFound="Existing certificate found in"
                    declare -r infoCompileCUDAExamples="Compiling the CUDA examples to enable DeviceQuery"
                    declare -r infoSharedMemory="Configure shared memory"
                    declare -r infoOpenCVCUDA="CUDA - Integration in OpenCV successful."
                    
                    declare -r createInstallationLog="Create FinalInstall.log"
                    
                    declare -r installUpdate="Update packages"
                    declare -r installCUDA="CUDA - Download and installation including graphics driver"
                    declare -r installcuDNN="Installation cuDNN"
                    declare -r installImagehandling="Install packages for image handling"
                    declare -r installCodecs="Install codecs"
                    declare -r installNVIDIACodecs="Install NVIDIA Codecs."
                    declare -r installCameras="Install packages for video and cameras"
                    declare -r installCompiler="Installing packages for compilers (general)"
                    declare -r installCompilerv7="Install packages for compiler (version 7)"
                    declare -r installCompilerv6="Install packages for compiler (version 6)"
                    declare -r installTools="Install various tools"
                    declare -r installPython37="Install Python 3.7"
                    declare -r installMathPacks="Install mathematical libraries"
                    declare -r installGoogle="Install Google Open Source Packages"
                    declare -r installDataManagement="Install packages for data management"
                    declare -r installMySQL="MySQL - Setup"
                    declare -r installPHP="PHP $PHP_VERS - Setup"
                    declare -r installZM="Zoneminder - Installation & Setup"
                    declare -r installZMAccessRights="Zoneminder - Set access rights"
                    declare -r installApacheSetup="Apache2 - Setup" 
                    declare -r installEventServer="EventServer - Setup" 
                    declare -r installFaceRecognition="Face recognition - Setup" 
                    declare -r installLAMP="LAMP - Setup"
                    declare -r installOpenCV="Compile OpenCV with Compute Capability $CUDA_COMPUTE_CAPABILITY"
                    declare -r installLibs="Install necessary packages"
                    declare -r installNASM="Compile nasm"
                    declare -r installx264="Compile libx264"
                    declare -r installLibfdkacc="Compile libfdk-acc"
                    declare -r installLibMP3Lame="Compile libmp3lame"
                    declare -r installLibOpus="Compile libopus"
                    declare -r installLibx265="Compile libx265"
                    declare -r installLibPvx="Compile libvpx"
                    declare -r installFFMPEG="Compile ffmpeg"
                    declare -r installBugfixes="Apply bug fixes"
                fi
                
                if [ "$(whoami)" != $Benutzer ]; then
                       echo $(date -u) $errorUser
                       exit 255
                fi
                   
                python3 -c 'import platform; version=platform.python_version(); print(version[0:3])' > ~/python.version
                
                if [ -f ~/python.version ]; then 
                    for i in ` sed s'/=/ /g' ~/python.version | awk '{print $1}' ` ; do
                        export PYTHON_VER=$i
                        if [ $PYTHON_VER \< "3.0" ] || [ $PYTHON_VER \> "3.9" ]; then  echo $(date -u) $checkPythonVersion | tee -a  ~/FinalInstall.log; exit 255; fi
                    done  
                else
                    echo $errorPythonVersion
                    exit 255
                fi
               
                Logging() {
                    echo $(date -u) "$1"  | tee -a  ~/FinalInstall.log
                }

                
                
                export DEBCONF_NONINTERACTIVE_SEEN="true"
                export DEBIAN_FRONTEND="noninteractive"
                export TZ="Europe/Berlin"
                export PYTHON_INCLUDE_DIRS=/usr/include/python$PYTHON_VER
                export PYTHON_LIBRARIES=/usr/lib/python$PYTHON_VER/config-$PYTHON_VER-x86_64-linux-gnu/libpython$PYTHON_VER.so
                export SHMEM="50%"
                export MULTI_PORT_START="0"
                export MULTI_PORT_END="0"
                export LINUX_VERSION_NAME=`lsb_release -sr`
                                 
                #Vorbelegung CompilerFlags und Warnungen zu unterdrücken die durch automatisch generierten Code schnell mal entstehen können und keine wirkliche Relevanz haben
                export CFLAGS=$CFLAGS" -w"
                export CPPFLAGS=$CPPFLAGS" -w"
                export CXXFLAGS=$CXXFLAGS" -w"
                
                echo $(date -u) "$checkInstallationLog"
                test -f ~/FinalInstall.log && rm ~/FinalInstall.log
                
                echo $(date -u) "$createInstallationLog"
                touch ~/FinalInstall.log
                 
                 
                if lshw -C display | grep -q 'nouveau'; then
                    echo $(date -u) $errorGPUDriver
                    exit 255
                fi

                if [[ ${LINUX_VERSION_NAME} == "18.04" ]]; then
                    export UBUNTU_VER="18.04"
                    export PHP_VERS="7.2"
                else
                   if [[ ${LINUX_VERSION_NAME} == "20.04" ]]; then
                       export UBUNTU_VER="20.04"
                       export PHP_VERS="7.2"
                   else
                       echo " "
                       echo $errorLinuxDist
                       exit 255
                   fi
                fi
                 

Logging "########################################################################################################################"
Logging "# Zoneminder - Objekterkennung mit OpenCV, CUDA, cuDNN und YOLO auf Ubuntu $UBUNTU_VER                       By WIEGEHTKI.DE #"
Logging "# Zur freien Verwendung. Ohne Gewaehr und nur auf Testsystemen anzuwenden                                              #" 
Logging "#                                                                                                                      #" 
Logging "# V2.0.0 (Rev a), 30.01.2021                                                                                           #" 
Logging "########################################################################################################################" 
                UpdatePackages() {
                    Logging "$installUpdate"                  
                    apt-get -y update
                    apt-get -y dist-upgrade
                    Logging "UpdatePackages $infoStepEnd"
                }
                InstallGPUTools() {
                    Logging "$installGPUTools"
                    if [ "$UBUNTU_VER" = "18.04" ]; then 
                        Logging "$infoStep1"
                        apt-get -y install libncurses5-dev libncursesw5-dev
                        cd ~
                        git clone https://github.com/Syllo/nvtop.git
                        mkdir -p nvtop/build && cd nvtop/build
                        cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True
                        #cmake ..
                        make -j$(nproc)
                        make install
                    else
                        Logging "$infoStep2"
                        if [ "$UBUNTU_VER" = "20.04" ]; then apt-get -y install nvtop; fi
                    fi
                    python3 -m pip install --upgrade --force-reinstall  glances[gpu]
                    if [ -f /usr/local/bin/glances ]; then mv /usr/local/bin/glances /usr/bin/; fi
                    Logging "$infoStepEnd"
                }
                InstallCuda() {
                    Logging "$installCUDA" 
                    cd ~
                    if ls cuda_* >/dev/null 2>&1; then rm -f ~/cuda_* &> /dev/null; fi
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
                        Logging "$infoCompileCUDAExamples" 
                                    
                        cd ~/$CUDA_EXAMPLES_PATH
                        make -j$(nproc) 
                        cd ~
                        if [ -f ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery ];  then 
                            ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery | tee -a  ~/FinalInstall.log
                            ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery | grep "CUDA Capability Major/Minor version number:" >  ~/ComputeCapability.CUDA
                            for i in ` sed s'/=/ /g' ~/ComputeCapability.CUDA | awk '{print $6}' `
                                do  
                                export CUDA_COMPUTE_CAPABILITY=$i
                                awk -v "a=$CUDA_COMPUTE_CAPABILITY" -v "b=10" 'BEGIN {printf "%.0f\n", a*b}' > ~/ComputeCapability.FFMPEG
                            done  
                        else
                            Logging "$errorDeviceQuery"  
                        fi
                        # PATH includes /usr/local/cuda-11.2/bin
                        # LD_LIBRARY_PATH includes /usr/local/cuda-11.2/lib64, or, add /usr/local/cuda-11.2/lib64 to /etc/ld.so.conf and run ldconfig as root
                        #return 0
                    else
                       Logging "$CUDA_Script $errorDownload"
                       echo " "
                       echo $CUDA_Script $errorDownload
                       #return 1
                    fi
                    Logging "InstallCuda $infoStepEnd"
                }
                InstallcuDNN() {
                    Logging "$installcuDNN" 
                    local cuDNNFile
                    cd ~
                    if [ -f ~/$CUDNN_VERSION_1804 ] && [ "$UBUNTU_VER" = "18.04" ]; then
                          cuDNNFile=$CUDNN_VERSION_1804
                    else
                        if [ -f ~/$CUDNN_VERSION_2004 ] && [ "$UBUNTU_VER" = "20.04" ]; then
                            cuDNNFile=$CUDNN_VERSION_2004
                        else
                            Logging "$errorcuDNN"
                            echo " "
                            echo $errorcuDNN
                            return 1
                        fi
                    fi
                    Logging "$infoStep1"
                    tar -xzvf $cuDNNFile
                    cp cuda/include/cudnn*.h /usr/local/cuda/include
                    cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
                    chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
                    cd /usr/local/cuda/lib64
                    if [ -f libcudnn.so ];   then rm libcudnn.so;   fi 
                    if [ -f libcudnn.so.8 ]; then rm libcudnn.so.8; fi 
                    ln libcudnn.so.8.0.5 libcudnn.so.8
                    ln libcudnn.so.8 libcudnn.so
                    
                    Logging "InstallcuDNN $infoStep2"
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
                    Logging "InstallcuDNN $infoStep3"
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
                    Logging "InstallcuDNN $infoStepEnd"
                    return 0                    
                }
                SetUpMySQL() {
                    Logging "$installMySQL"  
                    if [ $# -eq 0 ]; then
                        Logging "SetUpMySQL $infoStep1"
                        rm /etc/mysql/my.cnf  
                        cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf
                        
                        echo "default-time-zone='+01:00'" >> /etc/mysql/my.cnf
                        echo "sql_mode        = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf
                        mysql_tzinfo_to_sql /usr/share/zoneinfo/Europe | sudo mysql -u root mysql
                        mysql -e "SET GLOBAL time_zone = 'Berlin';"
                        systemctl restart mysql
                    else
                        Logging "SetUpMySQL $infoStep2"
                        #mysql -uroot --skip-password < /usr/share/zoneminder/db/zm_create.sql
                        mysql -uroot --skip-password < ~/zoneminder/database/Settings.sql
                        mysqladmin -uroot --skip-password reload
                    fi 
                    Logging "SetUpMySQL $infoStepEnd"
                }
                SetUpPHP() {
                    Logging "$installPHP"  
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
                    Logging "SetUpPHP $infoStepEnd"
                }
                AccessRightsZoneminder() {
                    Logging "$installZMAccessRights"  
                    chown root:www-data /etc/zm/zm.conf
                    chown -R www-data:www-data /usr/share/zoneminder/
                    chown root:www-data /etc/zm/conf.d/*.conf
                    chmod 640 /etc/zm/conf.d/*.conf
                    Logging "AccessRightsZoneminder $infoStepEnd"
                }
               
                SetUpApache2() {
                    Logging "$installApacheSetup" 
                    a2enmod cgi
                    a2enmod rewrite
                    a2enconf zoneminder
                    a2enmod expires
                    a2enmod headers
                    mkdir /etc/apache2/ssl/
                    mkdir /etc/zm/apache2/
                    mkdir /etc/zm/apache2/ssl/
                    chown -R  www-data:www-data /etc/apache2/ssl
                    mv /root/zoneminder/apache/default-ssl.conf    /etc/apache2/sites-enabled/default-ssl.conf
                    cp /etc/apache2/ports.conf                     /etc/apache2/ports.conf.default
                    cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default

                    Logging "SetUpApache2 $infoStep1"
                    echo "localhost" >> /etc/apache2/ssl/ServerName
                    export SERVER=`cat /etc/apache2/ssl/ServerName`
                    # Test wegen doppelten Einträgen UW 9.1.2021
                    (echo "ServerName" $SERVER && cat /etc/apache2/apache2.conf) > /etc/apache2/apache2.conf.old && mv  /etc/apache2/apache2.conf.old /etc/apache2/apache2.conf
                    if [[ -f /etc/apache2/ssl/cert.key && -f /etc/apache2/ssl/cert.crt ]]; then
                        echo "$infoSelfSignedCertificateFound \"/etc/apache2/ssl/cert.key\""  | tee -a  ~/FinalInstall.log
                    else
                        Logging "$infoSelfSignedCertificates"
                        mkdir -p /config/keys
                        dd if=/dev/urandom of=~/.rnd bs=256 count=1
                        chmod 600 ~/.rnd
                        openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /etc/apache2/ssl/cert.crt -keyout /etc/apache2/ssl/cert.key -subj "/C=DE/ST=HE/L=Frankfurt/O=Zoneminder/OU=Zoneminder/CN=localhost"
                    fi
                    Logging "SetUpApache2 $infoStep2"
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
                    Logging "SetUpApache2 $infoStepEnd"
                }
                InstallZoneminder() {
                    Logging "$installZM"  

                    if [ ZM_VERSION="1.35" ]; then add-apt-repository -y ppa:iconnor/zoneminder-master
                    else
                        if [ ZM_VERSION="1.34" ]; then add-apt-repository -y ppa:iconnor/zoneminder-1.34
                        else 
                            Logging "$errorZMVersion"
                            exit 255
                        fi
                    fi

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
                    Logging "InstallZoneminder $infoStep1"
                    UpdatePackages
                    Logging "$infoStep2"
                    SetUpMySQL
                    SetUpMySQL /usr/share/zoneminder/db/zm_create.sql
                    Logging "InstallZoneminder $infoStep3"
                    AccessRightsZoneminder
                    Logging "InstallZoneminder $infoStep3"
                    SetUpApache2
                    cp ~/zoneminder/Anzupassen/. /etc/zm/. -r
                    chmod +x /etc/zm/*
                    hostname -I > ~/ip.host

                    if [ -f ~/ip.host ]; then 
                        for i in ` sed s'/=/ /g' ~/ip.host | awk '{print $1}' ` ; do
                            sed -i "s/<PORTAL-ADRESSE>/${i}/g" /etc/zm/secrets.ini
                        done  
                    else
                        Logging "$errorDetectIP"
                        exit 255
                    fi
                    
                    systemctl enable zoneminder
                    systemctl start zoneminder
                    Logging "$infoStepEnd"
                }
                #EventServer installieren
                InstallEventserver() {
                    Logging "$installEventServer"  
                    apt-get -y install python3-numpy
                    python3 -m pip install scipy matplotlib ipython pandas sympy nose cython pyzm
                    cp -r ~/zoneminder/zmeventnotification/EventServer.zip ~/.
                    cd ~
                    chmod +x EventServer.zip
                    unzip EventServer
                    cd ~/EventServer
                    chmod -R +x *
                    ./install.sh --install-hook --install-es --no-install-config --no-interactive
                    cd ~
                    cp EventServer/zmeventnotification.ini /etc/zm/. -r
                    chmod +x /var/lib/zmeventnotification/bin/*

                    Logging "InstallEventserver $infoStep1"
                    yes | perl -MCPAN -e "install Crypt::MySQL"
                    yes | perl -MCPAN -e "install Config::IniFiles"
                    yes | perl -MCPAN -e "install Crypt::Eksblowfish::Bcrypt"

                    Logging "InstallEventserver $infoStep2"
                    apt -y install libyaml-perl
                    apt -y install make
                    yes | perl -MCPAN -e "install Net::WebSocket::Server"

                    Logging "InstallEventserver $infoStep3"
                    apt -y install libjson-perl
                    yes | perl -MCPAN -e "install LWP::Protocol::https"
                    yes | perl -MCPAN -e "install Net::MQTT::Simple"

                    Logging "InstallEventserver $infoStep4"
                    # Fix memory issue
                    Logging "$infoSharedMemory"
                    echo "Config" $SHMEM " - `awk '/MemTotal/ {print $2}' /proc/meminfo` bytes" | tee -a  ~/FinalInstall.log
                    umount /dev/shm
                    mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${SHMEM} tmpfs /dev/shm
                    chown -R www-data:www-data /etc/apache2/ssl/*
                    a2enmod ssl
                    systemctl restart apache2  
                    Logging "InstallEventserver $infoStepEnd"
                }
                #Apache, MySQL, PHP 
                InstallFaceRecognition() {
                    Logging "$installFaceRecognition"  
                    if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("dlib"))'; then sudo -H pip3 uninstall dlib; fi
                    if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("face-recognition"))'; then sudo -H pip3 uninstall face-recognition; fi
                    Logging "InstallFaceRecognition $infoStep1"
                    cd ~/zoneminder/dlib
                    python3 ./setup.py install 
                    python3 -m pip install face_recognition
                    cp -r ~/zoneminder/Bugfixes/face_train.py /usr/local/lib/python$PYTHON_VER/dist-packages/pyzm/ml/face_train.py
                    Logging "InstallFaceRecognition $infoStepEnd"
                }                        

                InstallLAMP() {
                    Logging "$installLAMP" 
                    apt-get -y install tasksel
                    tasksel install lamp-server
                    Logging "InstallLAMP $infoStepEnd"
                }                        

                InstallOpenCV(){
                    Logging "$installOpenCV"
                    apt-get -y install python3-pip \
                               python3-dev
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

                    Logging "InstallOpenCV $infoStep1"
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
                          -D CUDA_ARCH_PTX="$CUDA_COMPUTE_CAPABILITY" \
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
                    make install
                    pkg-config --cflags --libs opencv4
                    pkg-config --modversion opencv4

                    Logging "InstallOpenCV $checkOpenCV"
                    python -c 'import cv2; count = cv2.cuda.getCudaEnabledDeviceCount(); print(count)' >  ~/devices.cuda
                   
                    if [ -f ~/devices.cuda ]; then 
                        for i in ` sed s'/=/ /g' ~/devices.cuda | awk '{print $1}' ` ; do
                            if [ $i \> "0" ]; then Logging "$infoOpenCVCUDA"; else Logging "$errorOpenCVCUDA"; exit 255; fi
                        done  
                    else
                        Logging "$checkOpenCVCUDA"
                        exit 255
                    fi
                    Logging "InstallOpenCV $infoStepEnd"
                }
 
                InstallLibs(){
                    Logging "$installLibs"
                    sudo apt-get update
                    sudo apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
                    libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
                    libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev libopus-dev
                    Logging "InstallLibs $infoStepEnd"
                }
                 
                #Install nvidia SDK
                InstallSDK(){
                    Logging  "$installNVIDIACodecs"
                    cd ~/ffmpeg_sources
                    cd ~/ffmpeg_sources
                    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
                    cd nv-codec-headers
                    Logging "InstallSDK $infoStep1"
                    make -j$(nproc)
                    Logging "InstallSDK $infoStep2"
                    sudo make install
                    Logging "InstallSDK $infoStepEnd"
                }
                
                #nasm
                CompileNasm(){
                    Logging "$installNASM"
                    cd ~/ffmpeg_sources
                    wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz
                    tar xzvf nasm-2.15.05.tar.gz
                    cd nasm-2.15.05
                    Logging "CompileNasm $infoStep1"
                    ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
                    Logging "CompileNasm $infoStep2"
                    make -j$(nproc)
                    Logging "CompileNasm $infoStep3"
                    make -j$(nproc) install
                    Logging "CompileNasm $infoStep4"
                    make -j$(nproc) distclean
                    Logging "CompileNasm $infoStepEnd"
                }
                
                #libx264
                CompileLibX264(){
                    Logging "$installx264"
                    cd ~/ffmpeg_sources
                    wget https://download.videolan.org/pub/x264/snapshots/x264-snapshot-20191217-2245-stable.tar.bz2 
                    tar xjvf x264-snapshot-20191217-2245-stable.tar.bz2
                    cd x264-snapshot-20191217-2245-stable
                    Logging "CompileLibX264 $infoStep1"
                    PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl
                    PATH="$HOME/bin:$PATH" make -j$(nproc)
                    Logging "CompileLibX264 $infoStep2"
                    make -j$(nproc) install
                    Logging "CompileLibX264 $infoStep3"
                    make -j$(nproc) distclean
                    Logging "CompileLibX264 $infoStepEnd"
                }
                
                #libfdk-acc
                CompileLibfdkacc(){
                    Logging "$installLibfdkacc"
                    sudo apt-get install unzip
                    cd ~/ffmpeg_sources
                    wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
                    unzip fdk-aac.zip
                    Logging "CompileLibfdkacc $infoStep1"
                    cd mstorsjo-fdk-aac*
                    autoreconf -fiv
                    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
                    Logging "CompileLibfdkacc $infoStep2"
                    make -j$(nproc)
                    Logging "CompileLibfdkacc $infoStep3"
                    make -j$(nproc) install
                    Logging "CompileLibfdkacc $infoStep4"
                    make -j$(nproc) distclean
                    Logging "CompileLibfdkacc $infoStepEnd"
                }

                #libmp3lame
                CompileLibMP3Lame(){
                    Logging "$installLibMP3Lame"
                    sudo apt-get install nasm
                    cd ~/ffmpeg_sources
                    wget http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
                    tar xzvf lame-3.100.tar.gz
                    Logging "CompileLibMP3Lame $infoStep1"
                    cd lame-3.100
                    ./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
                    Logging "CompileLibMP3Lame $infoStep2"
                    make -j$(nproc)
                    Logging "CompileLibMP3Lame $infoStep3"
                    make -j$(nproc) install
                    Logging "CompileLibMP3Lame $infoStep4"
                    make -j$(nproc) distclean
                    Logging "CompileLibMP3Lame $infoStepEnd"
                }
                
                #libopus
                CompileLibOpus(){
                    Logging "$installLibOpus"
                    cd ~/ffmpeg_sources
                    wget http://downloads.xiph.org/releases/opus/opus-1.3.1.tar.gz
                    tar xzvf opus-1.3.1.tar.gz
                    cd opus-1.3.1
                    Logging "CompileLibOpus $infoStep1"
                    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
                    Logging "CompileLibOpus $infoStep2"
                    make -j$(nproc)
                    Logging "CompileLibOpus $infoStep3"
                    make -j$(nproc) install
                    Logging "CompileLibOpus $infoStep4"
                    make -j$(nproc) distclean
                    Logging "CompileLibOpus $infoStepEnd"
                }
    
                #libx265
                CompileLibX265(){
                    Logging "$installLibx265"               
                    cd ~
                    git clone https://bitbucket.org/multicoreware/x265_git
                    cd x265_git/build/linux
                    Logging "CompileLibX265 $infoStep1"
                    cmake -G "Unix Makefiles" ../../source
                    Logging "CompileLibX265 $infoStep2"
                    make install
                    Logging "CompileLibX265 $infoStepEnd"
                }
    
                #libvpx
                CompileLibPvx(){
                    Logging "$installLibPvx"
                    cd ~/ffmpeg_sources
                    git clone https://chromium.googlesource.com/webm/libvpx
                    cd libvpx
                    Logging "CompileLibPvx $infoStep1"
                    PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
                    --enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-better-hw-compatibility --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only \
                    --cpu=native --as=nasm
                    Logging "CompileLibPvx $infoStep2"
                    PATH="$HOME/bin:$PATH" make -j$(nproc)
                    Logging "CompileLibPvx $infoStep3"
                    make -j$(nproc) install
                    Logging "CompileLibPvx $infoStep4"
                    make -j$(nproc) clean
                    Logging "CompileLibPvx $infoStepEnd"
                }
                
                #ffmpeg
                CompileFfmpeg(){
                    Logging "$installFFMPEG"
                    cd ~
                    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
                    cd ~/nv-codec-headers/
                    Logging "CompileFfmpeg $infoStep1"
                    make install
                    cd ~
                    Logging "CompileFfmpeg $infoStep2"
                    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg_sources/
                    cd ~/ffmpeg
                    Logging "CompileFfmpeg $infoStep3"
                    if [ -f ~/ffmpeg/configure ]; then 
                        if [ -f ~/ComputeCapability.FFMPEG ]; then 
                            for i in ` sed s'/=/ /g' ~/ComputeCapability.FFMPEG | awk '{print $1}' ` ; do
                                export COMPUTE_COMP=$i
                            done
                            sed -i "s/compute_30,code=sm_30/compute_$COMPUTE_COMP,code=sm_$COMPUTE_COMP/g" ~/ffmpeg/configure
                            sed -i "s/cuda-gpu-arch=sm_30/cuda-gpu-arch=sm_${COMPUTE_COMP}/g" ~/ffmpeg/configure
                        fi                            
                    fi
                    ./configure --enable-nonfree --enable-cuda-nvcc --enable-cuda --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64
                    make -j$(nproc) 
                    Logging "CompileFfmpeg $infoStep4" 
                    make install
                    if [ -f /usr/local/bin/ffmpeg ]; then cp /usr/local/bin/ffmpeg /usr/bin/ffmpeg; fi
                    if [ -f /usr/local/bin/ffmpeg ]; then cp /usr/local/bin/ffmpeg /usr/share/ffmpeg; fi
                   
                    Logging "CompileFfmpeg $infoStepEnd"
                }

                #Bugfixing und Finalisierung
                BugFixes_Init() {
                    Logging "$installBugfixes"
                    python3 -m pip install protobuf==3.3.0
                    python3 -m pip install numpy==1.16.5
                    
                    yes | perl -MCPAN -e "upgrade IO::Socket::SSL"
                    cd ~
                    zmupdate.pl -f
                    Logging "BugFixes_Init $infoStepEnd"
                }
                                
                Logging "Main $infoStartInstallation"  
                if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
                   echo "Setzen der Zeitzone auf: $TZ"
                   echo $TZ > /etc/timezone
                   ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
                   dpkg-reconfigure tzdata -f noninteractive
                   #echo "Datum: `date`"
                fi
                if InstallCuda $1;  then echo "InstallCuda ok"  | tee -a  ~/FinalInstall.log; else echo "$errorCUDAInstall" $1  | tee -a  ~/FinalInstall.log; exit 255; fi
                if InstallcuDNN $1; then echo "InstallcuDNN ok" | tee -a  ~/FinalInstall.log; else echo "$errorcuDNNInstall" $1 | tee -a  ~/FinalInstall.log; exit 255; fi
                UpdatePackages
                InstallLamp
                SetUpPHP
                InstallZoneminder
                InstallEventserver
                BugFixes_Init
                InstallFaceRecognition
                AccessRightsZoneminder
                InstallOpenCV
                BugFixes_Init
                AccessRightsZoneminder
                if [ "$UBUNTU_VER" = "20.04" ]; then CompileFfmpeg; fi
                InstallGPUTools
                Logging "Main $infoEndofInstallation"

  

                 
               

                cd ~
                mkdir ffmpeg_sources
                # installLibs
                # InstallCUDASDK
                # InstallSDK
                # CompileNasm
                # CompileLibX264
                # CompileLibX265
                # CompileLibfdkacc
                # CompileLibMP3Lame
                # CompileLibOpus
                # CompileLibPvx
                # The process
                # export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
                # export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
                # CompileFfmpeg
                # Bei 18.04?
                # cp ~/bin/ffmpeg  /usr/bin/ -r
                # echo "Libraries und ffmpeg kompiliert!"
                # rm *.zip
                # logger "Compiling opencv..." -tEventServer

                #Test:
                #https://zm.wiegehtki.de/zm/api/host/getVersion.json
                #https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=snapshot
                #https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=alarm

                ##### Verzeichnis für Gesichtstraining
                #/var/lib/zmeventnotification/known_faces

                #sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
                #sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid 1 --monitorid 1 --debug
                #chown -R www-data:www-data /var/lib/zmeventnotification/known_faces
                #echo "<DEINE_IP>  <DEINE_DOMAIN>" >> /etc/hosts

                ##### Link für Reolink Kameras, getestet mit RL410 #####
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



