#!/usr/bin/env bash
    Benutzer="root"
    Language="German"

    if [ $Language = "German" ]; then
        declare -r errorUser="Script muss als Benutzer: $Benutzer ausgeführt werden!"
        declare -r errorPythonVersion="Probleme beim Auslesen der Python - Version, Abbruch..."
        declare -r errorLinuxDistribution="Keine gültige Distribution, Installer wird beendet"

        declare -r checkGPUDriver="Nouveau - Grafiktreiber de-aktivieren"
        declare -r checkPythonVersion="Keine unterstützte Python3 - Version gefunden, installiere Python 3.7.x"
        declare -r checkInstallationLog="Test auf bestehende Installation.log"
        declare -r checkHW_OS="Hardware_und_Linux Check"

        declare -r infoEndofInstallation="Ende der Initialisierung, initialisiere einen Neustart..."
        declare -r createInstallationLog="Installation.log anlegen"

        declare -r infoStep1="...Stufe 1"
        declare -r infoStep2="...Stufe 2"
        declare -r infoStep3="...Stufe 3"
        declare -r infoStep4="...Stufe 4"
        declare -r infoStep5="...Stufe 5"
        declare -r infoStepEnd="...Beendet"

        declare -r installGPUTools="GPU - Tools installieren"
        declare -r installUpdate="Pakete aktualisieren"
        declare -r installImagehandling="Pakete für Imagehandling installieren"
        declare -r installCodecs="Codecs installieren"
        declare -r installCameras="Pakete für Video und Kameras installieren"
        declare -r installCompiler="Pakete für Compiler (allgemein) installieren"
        declare -r installCompilerv7="Pakete für Compiler (Version 7) installieren"
        declare -r installCompilerv6="Pakete für Compiler (Version 6) installieren"
        declare -r installTools="Diverse Tools installieren"
        declare -r installPython37="Python 3.7 installieren"
        declare -r installMathPacks="Mathematische Bibliotheken installieren"
        declare -r installGoogle="Google Open-Source Pakete installieren"
        declare -r installDataManagement="Pakete für Datenmanagement installieren"
    else
        declare -r errorUser="Script must be executed as user: $Benutzer !"
        declare -r errorPythonVersion="Problems reading out the Python version, abort..."
        declare -r errorLinuxDistribution="No valid distribution, installer exits"

        declare -r checkGPUDriver="Nouveau - Deactivate graphics drive"
        declare -r checkPythonVersion="No supported Python3 version found, install Python 3.7.x"
        declare -r checkInstallationLog="Test for existing installation.log"
        declare -r checkHW_OS="Hardware_and_Linux check"

        declare -r infoStep1="...Step 1"
        declare -r infoStep2="...Step 2"
        declare -r infoStep3="...Step 3"
        declare -r infoStep4="...Step 4"
        declare -r infoStep5="...Step 5"
        declare -r infoStepEnd="...completed"

        declare -r infoEndofInstallation="End of initialisation, initialise a restart..."
        declare -r createInstallationLog="Create Installation.log"

        declare -r installGPUTools="Install GPU Tools"
        declare -r installUpdate="Update packages"
        declare -r installImagehandling="Install packages for image handling"
        declare -r installCodecs="Install codecs"
        declare -r installCameras="Install packages for video and cameras"
        declare -r installCompiler="Installing packages for compilers (general)"
        declare -r installCompilerv7="Install packages for compiler (version 7)"
        declare -r installCompilerv6="Install packages for compiler (version 6)"
        declare -r installTools="Install various tools"
        declare -r installPython37="Install Python 3.7"
        declare -r installMathPacks="Install mathematical libraries"
        declare -r installGoogle="Install Google Open Source Packages"
        declare -r installDataManagement="Install packages for data management"
    fi

    if [ "$(whoami)" != $Benutzer ]; then
        ColErr="\033[1;31m"
        NoColErr="\033[0m"
        echo -e ${ColErr}$(date -u) $errorUser ${NoColErr}
        exit 255
    fi

    echo $(date -u) "$checkInstallationLog"
    test -f ~/Installation.log && rm ~/Installation.log

    echo $(date -u) "$createInstallationLog"
    touch ~/Installation.log
    #Linux-Version erkennen
    export LINUX_VERSION_NAME=`lsb_release -sr`

    if [[ ${LINUX_VERSION_NAME} == "18.04" ]]; then
        export UBUNTU_VER="18.04"
    else
        if [[ ${LINUX_VERSION_NAME} == "20.04" ]]; then
            export UBUNTU_VER="20.04"
        else
            if [[ ${LINUX_VERSION_NAME} == "21.10" ]]; then
                export UBUNTU_VER="21.10"
            else
                if [[ ${LINUX_VERSION_NAME} == "22.04" ]]; then
                    export UBUNTU_VER="22.04"
                else
                    echo " "
                    ColErr="\033[1;31m"
                    NoColErr="\033[0m"
                    echo -e ${ColErr}$(date -u) $errorLinuxDistribution ${NoColErr}
                    exit 255
                fi
            fi
        fi
    fi

    Logging() {
        echo $(date -u) "$1"  | tee -a  ~/Installation.log
    }

    #Debug Modus: -x = an, +x = aus
    set +x

    #Stoppen, sobald ein Fehler auftritt
    set -e

    Logging "#####################################################################################################################################"
    Logging "# Zoneminder - Objekterkennung mit OpenCV und YOLO. Support für Ubuntu $UBUNTU_VER                                  By WIEGEHTKI.DE #"
    Logging "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                                            #"
    Logging "#                                                                                                                                   #"
    Logging "# v2.2.0 (Rev a), 12.02.2022                                                                                                        #"
    Logging "#####################################################################################################################################"
    Logging "....................................................................................................................................."
    Logging "$checkHW_OS"
    lshw -C display | tee -a  ~/Installation.log
    uname -m && cat /etc/*release | tee -a  ~/Installation.log

    Logging "....................................................................................................................................."
    UpdatePackages() {
    Logging "$installUpdate"
        apt-get -y update
        apt-get -y dist-upgrade
        Logging "$infoStepEnd"
    }
    InstallImageHandling() {
        Logging "$installImagehandling"
        apt-get -y install libjpeg-dev \
                       libpng-dev \
                       libtiff-dev
        Logging "$infoStepEnd"
    }
    InstallCodecs() {
        Logging "$installCodecs"
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
        Logging "$infoStepEnd"
    }
    InstallVideo4Camera() {
        Logging "$installCameras"
        if [ "$UBUNTU_VER" = "18.04" ]; then apt-get -y install libdc1394-22; fi
        if [ "$UBUNTU_VER" = "20.04" ]; then apt-get -y install libdc1394-22; fi
        if [ "$UBUNTU_VER" = "22.04" ]; then apt-get -y install libdc1394-utils; fi
        
        if [ "$UBUNTU_VER" = "22.04" ]; then
            apt-get -y install libdc1394-dev \
                               libxine2-dev \
                               libv4l-dev \
                               v4l-utils \
                               libraw1394-doc \
                               libgphoto2-dev \
                               libva-dev
        else
            apt-get -y install libdc1394-22-dev \
                               libxine2-dev \
                               libv4l-dev \
                               v4l-utils \
                               libraw1394-doc \
                               libgphoto2-dev \
                               libva-dev
        fi
                           
        Logging "$infoStep1"
        cd /usr/include/linux
        ln -s -f ../libv4l1-videodev.h videodev.h
        Logging "$infoStepEnd"
    }
    InstallCompiler() {
        Logging "$installCompiler"
        apt-get -y install linux-headers-$(uname -r) \
                           pkg-config \
                           gcc \
                           make \
                           build-essential \
                           cmake \
                           yasm \
                           gfortran
        Logging "$infoStepEnd"
    }
    InstallCompiler_v7() {
        Logging "$installCompilerv7"
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
        Logging "$infoStep1"
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 99
        update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 99
        if [ -f /usr/bin/gcc ]; then rm /usr/bin/gcc; fi
        if [ -f /usr/bin/g++ ]; then rm /usr/bin/g++; fi
        Logging "$infoStep2"
        ln -s /usr/bin/gcc-7 /usr/bin/gcc
        ln -s /usr/bin/g++-7 /usr/bin/g++
        Logging "$infoStepEnd"
    }
    InstallCompiler_v6() {
        Logging "$installCompilerv6"
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
        Logging "$infoStep1"
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 99
        update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 99
        if [ -f /usr/bin/gcc ]; then rm /usr/bin/gcc; fi
        if [ -f /usr/bin/g++ ]; then rm /usr/bin/g++; fi
        Logging "$infoStep2"
        ln -s /usr/bin/gcc-6 /usr/bin/gcc
        ln -s /usr/bin/g++-6 /usr/bin/g++
        Logging "$infoStepEnd"
    }
    InstallTools() {
        Logging "$installTools"
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
        Logging "$infoStepEnd"
    }
    InstallPython3.7() {
        Logging "$installPython37"
        if [ "$UBUNTU_VER" = "20.04" ]; then add-apt-repository -y ppa:deadsnakes/ppa; UpdatePackages; fi
        apt -y install build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev
        cd /usr/src
        sudo wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz
        sudo tar xzf Python-3.7.9.tgz
        cd Python-3.7.9
        Logging "$infoStep1"
        sudo ./configure --enable-optimizations
        sudo make altinstall

        #apt-get update --fix-missing
        #apt-get -y install python3.7
        #apt-get -y install python3.7-dev
        #apt-get -y install python3-testresources
        #apt-get -y install python3-pip

        Logging "$infoStep2"
        if [ -f /usr/bin/python ];  then rm /usr/bin/python;  fi
        if [ -f /usr/bin/python3 ]; then rm /usr/bin/python3; fi
        ln -sf python3.7 /usr/bin/python
        ln -sf python3.7 /usr/bin/python3

        #apt-get -y remove --purge python3-apt
        #apt-get -y autoremove
        #apt-get -y install python3-apt
        #apt-get update  --fix-missing
        echo "3.7" > ~/python.version
        Logging "$infoStepEnd"
    }

    InstallMathPacks() {
        Logging "$installMathPacks"
        apt-get -y install libatlas-base-dev \
                           libeigen3-dev \
                           libopenblas-dev \
                           liblapack-dev \
                           libblas-dev
        Logging "$infoStepEnd"
    }
    InstallGooglePacks() {
        Logging "$installGoogle"
        apt-get -y install libprotobuf-dev \
                           protobuf-compiler \
                           libgoogle-glog-dev
        Logging "$infoStepEnd"
    }
    InstallDataManagement() {
        Logging "$installDataManagement"
        apt-get -y install libhdf5-dev
        Logging "$infoStepEnd"
    }
    DeactivateNouveau() {
        Logging "$checkGPUDriver"
        bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
        bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
        echo "cd ~/" >> /root/.bashrc
        update-initramfs -u
        Logging "$infoStepEnd"
    }
    chmod -R +x ~/zoneminder/*
    apt-get -y install software-properties-common
    UpdatePackages
    InstallTools
    InstallCompiler
    InstallImageHandling
    InstallCodecs
    InstallVideo4Camera
    InstallGooglePacks
    InstallMathPacks
    InstallDataManagement
 
    python3 -c 'import platform; version=platform.python_version(); print(version[0:3])' > ~/python.version
    if [ -f ~/python.version ]; then
        for i in ` sed s'/=/ /g' ~/python.version | awk '{print $1}' `
            do
            export PYTHON_VER=$i
        done
    else
        ColErr="\033[1;31m"
        NoColErr="\033[0m"
        echo -e ${ColErr}$(date -u) $errorPythonVersion ${NoColErr}
        exit 255
    fi

    if [ $PYTHON_VER \< "3.0" ] || [ $PYTHON_VER \> "3.9" ]; then
        Logging "$checkPythonVersion"
        InstallPython3.7
    fi
    echo 'export PYTHONPATH=/usr/local/lib/python'$PYTHON_VER'/site-packages:/usr/local/lib/python'$PYTHON_VER'/site-packages/cv2/python-'$PYTHON_VER':$PYTHONPATH' >> ~/.bashrc
    if [ $PYTHON_VER == "3.8" ]; then echo 'PYTHONPATH='"\""/usr/local/lib/python$PYTHON_VER/site-packages:/usr/local/lib/python$PYTHON_VER/site-packages/cv2/python-$PYTHON_VER:"\""  >> /etc/environment; fi
    
    cd ~
    if [ "$UBUNTU_VER" == "18.04" ]; then
        if [ -f /usr/bin/python ]; then rm /usr/bin/python; fi
        ln -sv /usr/bin/python3.6 /usr/bin/python
        apt-get -y install python3-testresources \
                           python3-pip
        InstallCompiler_v6
    fi
    if [ "$UBUNTU_VER" == "20.04" ]; then apt-get -y install python-is-python3 python3-pip; InstallCompiler_v7; fi
    if [ "$UBUNTU_VER" == "21.10" ]; then apt-get -y install python-is-python3 python3-pip; fi
    if [ "$UBUNTU_VER" == "22.04" ]; then apt-get -y install python-is-python3 python3-pip; fi
    
    #apt-get -y install libzmq3-dev
    pip install --upgrade pip
    DeactivateNouveau
    Logging "$infoEndofInstallation"
    reboot
