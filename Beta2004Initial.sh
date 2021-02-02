#!/usr/bin/env bash
                # Es wird empfohlen root als Benutzer zu verwenden
                Benutzer="root"
                if [ "$(whoami)" != $Benutzer ]; then
                    echo $(date -u) "Script muss als Benutzer $Benutzer ausgeführt werden!"
                    exit 255
                fi
                echo $(date -u) "Test auf bestehende Installation.log"
                test -f ~/Installation.log && rm ~/Installation.log
                echo $(date -u) "Installation.log anlegen"
                touch ~/Installation.log
                
                #Linux-Version erkennen
                export LINUX_VERSION_NAME=`lsb_release -sr`


                if [[ ${LINUX_VERSION_NAME} == "18.04" ]]; then
                    export UBUNTU_VER="18.04"
                else
                    if [[ ${LINUX_VERSION_NAME} == "20.04" ]]; then
                        export UBUNTU_VER="20.04"
                    else
                        echo " "
                        echo "Keine gültige Distribution, Installer wird beendet"
                        exit
                    fi
                fi
                
                Logging() {
                    echo $(date -u) "$1"  | tee -a  ~/Installation.log
                }
                
                #Debug Modus: -x = an, +x = aus
                set +x

                #Stoppen, sobald ein Fehler auftritt
                set -e
                
                
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "# Zoneminder - Objekterkennung mit OpenCV und YOLO. Support für Ubuntu 18.04 LTS und 20.04 LTS                      By WIEGEHTKI.DE #" | tee -a  ~/Installation.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                                            #" | tee -a  ~/Installation.log
echo $(date -u) "#                                                                                                                                   #" | tee -a  ~/Installation.log
echo $(date -u) "# v2.0.1 (Rev a), 27.01.2021                                                                                                        #" | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                Logging "Hardware- und Linux - Check"
                lshw -C display | tee -a  ~/Installation.log
                uname -m && cat /etc/*release | tee -a  ~/Installation.log
                
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                UpdatePackages() {
                Logging "Pakete aktualisieren"
                    apt-get -y update
                    apt-get -y dist-upgrade
                }
                InstallImageHandling() {
                    Logging "Pakete für Imagehandling installieren"                 
                    apt-get -y install libjpeg-dev \
                                   libpng-dev \
                                   libtiff-dev 
                }
                InstallCodecs() {
                    Logging "Codecs installierenLogging"                 
                    apt-get -y install libgstreamer1.0-dev \
                                       libgstreamer-plugins-base1.0-dev \
                                       libxvidcore-dev \
                                       x264 \
                                       libx264-dev \
                                       libfaac-dev \
                                       libmp3lame-dev \
                                       libtheora-dev \
                                       libvorbis-dev \
                                       libopencore-amrnb-dev \
                                       libopencore-amrwb-dev
                }
                InstallVideo4Camera() {
                    Logging "Pakete für Video und Kameras installieren"
                    apt-get -y install libdc1394-22 \
                                       libdc1394-22-dev \
                                       libxine2-dev \
                                       libv4l-dev \
                                       v4l-utils \
                                       libraw1394-doc \
                                       libgphoto2-dev
                    cd /usr/include/linux
                    ln -s -f ../libv4l1-videodev.h videodev.h 
                }
                InstallCompiler() {
                    Logging "Pakete für Compiler (allgemein) installieren"                
                    apt-get -y install linux-headers-$(uname -r) \
                                       pkg-config \
                                       gcc \
                                       make \
                                       build-essential \
                                       cmake \
                                       yasm \
                                       gfortran
                }
                InstallCompiler_v7() {
                    Logging "Pakete für Compiler (Version 7) installieren"            
                    apt-get -y install build-essential 
                    apt-get -y install gcc-7 
                    apt-get -y install g++-7 
                    apt-get -y install zlib1g-dev 
                    apt-get -y install libncurses5-dev 
                    apt-get -y install libgdbm-dev 
                    apt-get -y install libnss3-dev 
                    apt-get -y install libssl-dev 
                    apt-get -y install libreadline-dev 
                    apt-get -y install libffi-dev 
                    apt-get -y install libtbb2
                    apt-get -y install libtbb-dev 
                    apt-get -y install libtbb-doc 
                    apt-get -y install libgflags-dev
                    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 99
                    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 99
                    if [ -f /usr/bin/gcc ]; then rm /usr/bin/gcc; fi
                    if [ -f /usr/bin/g++ ]; then rm /usr/bin/g++; fi
                    ln -s /usr/bin/gcc-7 /usr/bin/gcc
                    ln -s /usr/bin/g++-7 /usr/bin/g++
                }
                InstallCompiler_v6() {
                    Logging "Pakete für Compiler (Version 6) installieren"
                    apt-get -y install gcc-6 
                    apt-get -y install g++-6 
                    apt-get -y install build-essential 
                    apt-get -y install zlib1g-dev  
                    apt-get -y install libncurses5-dev  
                    apt-get -y install libgdbm-dev 
                    apt-get -y install libnss3-dev 
                    apt-get -y install libssl-dev 
                    apt-get -y install libreadline-dev  
                    apt-get -y install libffi-dev 
                    apt-get -y install libtbb-dev 
                    apt-get -y install libtbb-doc 
                    apt-get -y install libgflags-dev
                    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 99
                    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 99
                    if [ -f /usr/bin/gcc ]; then rm /usr/bin/gcc; fi
                    if [ -f /usr/bin/g++ ]; then rm /usr/bin/g++; fi
                    ln -s /usr/bin/gcc-6 /usr/bin/gcc
                    ln -s /usr/bin/g++-6 /usr/bin/g++
                }
                InstallTools() {
                    Logging "Diverse Tools installieren"
                    apt-get -y install nano  \
                                       letsencrypt \
                                       doxygen \
                                       unzip \
                                       git \
                                       gitlab-shell \
                                       wget \
                                       checkinstall \
                                       liblzma-dev \
                                       liblzma-doc \
                                       libgtk-3-dev \
                                       ntp \
                                       ntp-doc \
                                       ssmtp \
                                       mailutils \
                                       net-tools
                }
                InstallPython3.7() {
                    Logging "Python 3.7 installieren"
                    if [ "$UBUNTU_VER" = "20.04" ]; then
                        add-apt-repository -y ppa:deadsnakes/ppa
                        UpdatePackages
                    fi
                    
                    apt-get update --fix-missing
                    apt-get -y install python3.7 
                    apt-get -y install python3.7-dev 
                    apt-get -y install python3-testresources 
                    apt-get -y install python3-pip
                    
                    if [ -f /usr/bin/python ];  then rm /usr/bin/python;  fi
                    if [ -f /usr/bin/python3 ]; then rm /usr/bin/python3; fi
                    ln -sf python3.7 /usr/bin/python
                    ln -sf python3.7 /usr/bin/python3
                    
                    apt-get -y remove --purge python3-apt
                    apt-get -y autoremove
                    apt-get -y install python3-apt
                    apt-get update  --fix-missing
                    echo "3.7" > ~/python.version
                }

                InstallMathPacks() {
                    Logging "Mathematische Bibliotheken installieren"
                    apt-get -y install libatlas-base-dev \
                                       libeigen3-dev \
                                       libopenblas-dev \
                                       liblapack-dev \
                                       libblas-dev 
                }
                InstallGooglePacks() {
                    Logging "Google Open-Source Pakete installieren"
                    apt-get -y install libprotobuf-dev \
                                       protobuf-compiler \
                                       libgoogle-glog-dev
                }
                InstallDataManagement() {
                    Logging "Pakete für Datenmanagement installieren"
                    apt-get -y install libhdf5-dev
                }
                DeactivateNouveau() {
                    Logging "Nouveau - Grafiktreiber de-aktivieren"
                    bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
                    bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
                    echo "cd ~/" >> /root/.bashrc
                    update-initramfs -u
                }

                apt -y install software-properties-common
                UpdatePackages
                InstallTools
                InstallCompiler
                InstallImageHandling
                InstallCodecs
                InstallVideo4Camera
                InstallGooglePacks
                InstallMathPacks
                InstallDataManagement
                
                python -c 'import platform; version=platform.python_version(); print(version[0:3])' > ~/python.version
                if [ -f ~/python.version ];   then 
                    for i in ` sed s'/=/ /g' ~/python.version | awk '{print $1}' `
                        do  
                        export PYTHON_VER=$i
                        declare var="$i"
                    done  
                else
                    echo "Probleme beim Auslesen der Python - Version, Abbruch..."
                    exit 255
                fi
                
                if [ $PYTHON_VER \< "3.0" ] || [ $PYTHON_VER \> "3.7" ]; then
                    Logging "Keine unterstützte Pyton3 - Version gefunden, installiere Python 3.7.x"  
                    InstallPython3.7
                fi

                cd ~
                if [ "$UBUNTU_VER" = "18.04" ]; then apt-get -y install python3-testresources; InstallCompiler_v6; fi
                if [ "$UBUNTU_VER" = "20.04" ]; then InstallCompiler_v7; fi               

                DeactivateNouveau
                lshw -C display | tee -a  ~/Installation.log
                Logging "Ende der Initialisierung, initialisiere einen Neustart..."
                reboot
