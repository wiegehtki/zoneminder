#!/usr/bin/env bash
    #Select
    # Es wird empfohlen root als Benutzer zu verwenden
    Benutzer="root"
    #export ZM_VERSION="1.35"
    export LINUX_VERSION_NAME=`lsb_release -sr`
    LINUX_MAJOR_VERSION="${LINUX_VERSION_NAME:0:2}"
	
    export ZM_VERSION="1.34"

    if [[ ${LINUX_MAJOR_VERSION} == "18" ]]; then
        export CUDA_VERSION="11.6"
    else
       if [[ ${LINUX_MAJOR_VERSION} == "20" ]]; then
           export CUDA_VERSION="11.6"
       else
           if [[ ${LINUX_MAJOR_VERSION} == "21" ]]; then
              export CUDA_VERSION="11.6"
           else
              if [[ ${LINUX_MAJOR_VERSION} == "22" ]]; then
                  export CUDA_VERSION="11.6"
              else
                  echo " "
                  ColErr="\033[1;31m"
                  NoColErr="\033[0m"
                  echo -e ${ColErr}$(date -u) $errorLinuxDist ${NoColErr}
                  exit 255
               fi
           fi
       fi
    fi
	
    touch $PWD/ExportControl.log
    export OPENCV_VER="4.6.0"
    echo "OPENCV_VER "$OPENCV_VER  | tee -a  $PWD/ExportControl.log
    echo "CUDA_VERSION "$CUDA_VERSION | tee -a  $PWD/ExportControl.log
    Language="German"

    if [ $Language = "German" ]; then
        declare -r errorUser="Script muss als Benutzer: $Benutzer ausgeführt werden!"
        declare -r errorPythonVersion="Probleme beim Auslesen der Python - Version, Abbruch..."
        declare -r errorLinuxDistribution="Keine gültige Distribution, Installer wird beendet"
        declare -r errorGPUDriver="NOUVEAU - Grafiktreiber muss de-aktiviert sein! Bitte Initial-Script pruefen bzw. vorher laufen lassen."
        declare -r errorDeviceQuery="Fehler beim  Ausfuehren von deviceQuery! Standardwert fuer CUDA_COMPUTE_CAPABILITY wird beibehalten!"
        declare -r errorCudaVersion="Angegebene CUDA - Version wird nicht unterstützt, Abbruch..."
        declare -r errorcuDNN="cuDNN - Installationsdatei konnte nicht gefunden werden, Abbruch..."
        declare -r errorDownload="konnte nicht herunter geladen werden, Abbruch..."
        declare -r errorCUDAInstall="Fehler bei InstallCuda, Fehlernummer:"
        declare -r errorcuDNNInstall="Fehler bei InstallcuDNN, Fehlernummer:"
        declare -r errorOpenCVCUDA="CUDA - Integration in OpenCV fehlgeschlagen, Abbruch..."
        declare -r errorLinuxDist="Keine unterstützte Linux-Distribution, Installer wird beendet, Abbruch..."
        declare -r errorZMVersion="Keine gültige Zoneminder - Version angegeben, Abbruch..."
        declare -r errorDetectIP="IP-Adresse kann nicht ermittelt werden, Abbruch..."
        declare -r errorDetectPHP="PHP-Version kann nicht ermittelt werden, Abbruch..."
        declare -r errorDarknetRepoExist="darknet - Verzeichnis existiert bereits, Abbruch..."
        declare -r errorDarknetRepoNotExist="darknet - directory existiert nicht, Abbruch..."
        declare -r errorMakeYOLO="Fehler bei make - YOLO, Abbruch..."
        declare -r errorMakeYOLO_mark="Fehler bei make - YOLO_mark, Abbruch..."
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
        declare -r infoZMVersion="Es wird das Release 1.36.x von zoneminder installiert."
        #declare -r infoZMSelect="Drücken Sie ( 1 ) für Version 1.34.x oder irgendeine andere Taste für die Version 1.35.x"

        declare -r infoStartInstallation="Start der Installation"
        declare -r infoEndofInstallation="Ende der Installation, bitte Installation prüfen und Taste drücken um das System neu zu starten..."
        declare -r infoSelfSignedCertificates="Es werden self-signed keys in /etc/apache2/ssl/ generiert, bitte mit den eigenen Zertifikaten bei Bedarf ersetzen"
        declare -r infoSelfSignedCertificateFound="Bestehendes Zertifikat gefunden in"
        declare -r infoCompileCUDAExamples="Kompilieren der CUDA - Beispiele um DeviceQuery zu ermoeglichen"
        declare -r infoSharedMemory="Setzen shared memory"
        declare -r infoOpenCVCUDA="CUDA - Integration in OpenCV erfolgreich durchgeführt"
        declare -r infoMakeYOLO="make - YOLO erfolgreich beendet."
        declare -r infoMakeYOLO_mark="make - YOLO_mark erfolgreich beendet."

        declare -r createInstallationLog="FinalInstall.log anlegen"

        declare -r installUpdate="Pakete aktualisieren"
        declare -r installCUDA="CUDA - Download und Installation inklusive Grafiktreiber"
        declare -r installYOLO="YOLOv2-v4 - Download und Installation"
        declare -r installYOLO_mark="YOLO_mark Installation"
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
        declare -r errorCudaVersion="Specified CUDA version is not supported, abort..."
        declare -r errorcuDNN="cuDNN - Installation file could not be found, abort..."
        declare -r errorDownload="could not be downloaded, abort..."
        declare -r errorCUDAInstall="Error with InstallCuda, Error:"
        declare -r errorcuDNNInstall="Error with InstallcuDNN, Error:"
        declare -r errorOpenCVCUDA="CUDA - Integration in OpenCV failed, abort..."
        declare -r errorLinuxDist="No supported Linux distribution, installer quits, abort..."
        declare -r errorZMVersion="No valid Zoneminder version specified, abort..."
        declare -r errorDetectIP="IP address cannot be determined, abort..."
        declare -r errorDetectPHP="PHP version cannot be determined, abort..."
        declare -r errorDarknetRepoExist="darknet - directory already exist, abort..."
        declare -r errorDarknetRepoNotExist="darknet - directory does not exist, abort..."
        declare -r errorMakeYOLO="Error make - YOLO, abort..."
        declare -r errorMakeYOLO_mark="Error make - YOLO_mark, abort..."

        declare -r checkGPUDriver="Nouveau - Deactivate graphics drive"
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
        declare -r infoZMVersion="The 1.36.x release of zoneminder will be installed."
        declare -r infoZMSelect="Press ( 1 ) for version 1.34.x or any other key for version 1.35.x"

        declare -r infoStartInstallation="Start der Installation"
        declare -r infoEndofInstallation="End of installation, please check installation and press any key to restart the system."
        declare -r infoSelfSignedCertificates="Self-signed keys are generated in /etc/apache2/ssl/, please replace with your own certificates if necessary."
        declare -r infoSelfSignedCertificateFound="Existing certificate found in"
        declare -r infoCompileCUDAExamples="Compiling the CUDA examples to enable DeviceQuery"
        declare -r infoSharedMemory="Configure shared memory"
        declare -r infoOpenCVCUDA="CUDA - Integration in OpenCV successful."
        declare -r infoMakeYOLO="make - YOLO successful."
        declare -r infoMakeYOLO_mark="make - YOLO_mark successful."

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
        declare -r installYOLO="YOLOv2-v4 - Download and Installation"
        declare -r installYOLO_mark="YOLO_mark Installation"
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

   
     ######################### CUDA / cuDNN - Settings ############################################################################################
    if [ $CUDA_VERSION == "10.2" ]; then
        export CUDA_DOWNLOAD=https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run;
        export CUDNN_VERSION="cudnn-linux-x86_64-8.3.2.44_cuda10.2-archive.tar.xz"
        export CUDNN_DIRECTORY="cudnn-linux-x86_64-8.3.2.44_cuda10.2-archive"
        export cuDNN_MajorVersion="8.3.2"
        if [ ! -f ~/$CUDNN_VERSION ]; then
            echo $errorcuDNN
            exit 255
        fi
    else
        if [ $CUDA_VERSION == "11.6" ]; then
            export CUDA_DOWNLOAD=https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
            export CUDNN_VERSION="cudnn-linux-x86_64-8.4.0.27_cuda11.6-archive.tar.xz"
            export CUDNN_DIRECTORY="cudnn-linux-x86_64-8.4.0.27_cuda11.6-archive"
            export cuDNN_MajorVersion="8.4.0"
            if [ ! -f ~/$CUDNN_VERSION ]; then
               echo $errorcuDNN
               exit 255
            fi
        else 
#			if [ $CUDA_VERSION == "11.7" ]; then
#				export CUDA_DOWNLOAD=https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda_11.7.1_515.65.01_linux.run
#				export CUDNN_VERSION="cudnn-linux-x86_64-8.5.0.96_cuda11-archive.tar.xz"
#				export CUDNN_DIRECTORY="cudnn-linux-x86_64-8.5.0.96_cuda11-archive"
#				export cuDNN_MajorVersion="8.5.0"
#				if [ ! -f ~/$CUDNN_VERSION ]; then
#				   echo $errorcuDNN
#				   exit 255
#				fi
#			else
#				ColErr="\033[1;31m"
#				NoColErr="\033[0m"
#				echo -e ${ColErr}$(date -u) $errorCudaVersion ${NoColErr}
#				exit 255
#			fi
				if [ $CUDA_VERSION == "11.7" ]; then
					export CUDA_DOWNLOAD=https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
					export CUDNN_VERSION="cudnn-linux-x86_64-8.4.0.27_cuda11.6-archive.tar.xz"
					export CUDNN_DIRECTORY="cudnn-linux-x86_64-8.4.0.27_cuda11.6-archive"
					export cuDNN_MajorVersion="8.4.0"
					if [ ! -f ~/$CUDNN_VERSION ]; then
						echo $errorcuDNN
					exit 255
				else
					ColErr="\033[1;31m"
					NoColErr="\033[0m"
					echo -e ${ColErr}$(date -u) $errorCudaVersion ${NoColErr}
					exit 255
				fi
			fi
		fi
	fi

    export CUDA_PFAD_BASHRC="/usr/local/cuda-"$CUDA_VERSION"/bin"
    export CUDA_PFAD="/usr/local/cuda-"$CUDA_VERSION
    export CUDA_COMPUTE_CAPABILITY=6.1
    export CUDA_SEARCH_PATH="/usr/local/cuda-"$CUDA_VERSION"/lib64"
    export CUDA_EXAMPLES_PATH="cuda-samples/Samples"
    #export CUDA_EXAMPLES_PATH="NVIDIA_CUDA-"$CUDA_VERSION"_Samples"

    ######################## cuDNN - Settings #############################################################################################
    export CUDA_Script="$(basename $CUDA_DOWNLOAD)"
    export OPENCV_URL=https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
    export OPENCV_CONTRIB_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip

    echo "CUDA_DOWNLOAD "$CUDA_DOWNLOAD | tee -a  ~/ExportControl.log
    echo "CUDNN_VERSION "$CUDNN_VERSION | tee -a  ~/ExportControl.log
    echo "cuDNN_MajorVersion "$cuDNN_MajorVersion | tee -a  ~/ExportControl.log
    echo "CUDA_PFAD_BASHRC "$CUDA_PFAD_BASHRC | tee -a  ~/ExportControl.log
    echo "CUDA_PFAD "$CUDA_PFAD | tee -a  ~/ExportControl.log
    echo "CUDA_SEARCH_PATH "$CUDA_SEARCH_PATH | tee -a  ~/ExportControl.log
    echo "CUDA_EXAMPLES_PATH "$CUDA_EXAMPLES_PATH | tee -a  ~/ExportControl.log
    echo "CUDA_Script "$CUDA_Script | tee -a  ~/ExportControl.log
    echo "OPENCV_URL "$OPENCV_URL | tee -a  ~/ExportControl.log
    echo "OPENCV_CONTRIB_URL "$OPENCV_CONTRIB_URL | tee -a  ~/ExportControl.log

    if [ "$(whoami)" != $Benutzer ]; then
       ColErr="\033[1;31m"
       NoColErr="\033[0m"
       echo -e ${ColErr}$(date -u) $errorUser ${NoColErr}
       exit 255
    fi

    python3 -c 'import platform; version=platform.python_version(); print(version[0:3])' > ~/python.version

    if [ -f ~/python.version ]; then
        for i in ` sed s'/=/ /g' ~/python.version | awk '{print $1}' ` ; do
            export PYTHON_VER=$i
            if [ $PYTHON_VER \< "3.0" ] || [ $PYTHON_VER \> "3.9" ]; then  echo $(date -u) $checkPythonVersion | tee -a  ~/FinalInstall.log; exit 255; fi
        done
    else
        ColErr="\033[1;31m"
        NoColErr="\033[0m"
        echo -e ${ColErr}$(date -u) $errorPythonVersion ${NoColErr}
        exit 255
    fi
    echo "PYTHON_VER "$PYTHON_VER | tee -a  ~/ExportControl.log

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

    #Vorbelegung CompilerFlags und Warnungen zu unterdrücken die durch automatisch generierten Code schnell mal entstehen können und keine wirkliche Relevanz haben
    export CFLAGS=$CFLAGS" -w"
    export CPPFLAGS=$CPPFLAGS" -w"
    export CXXFLAGS=$CXXFLAGS" -w"

    echo $(date -u) "$checkInstallationLog"
    test -f ~/FinalInstall.log && rm ~/FinalInstall.log

    echo $(date -u) "$createInstallationLog"
    touch ~/FinalInstall.log

    if lshw -C display | grep -q 'nouveau'; then
        ColErr="\033[1;31m"
        NoColErr="\033[0m"
        echo -e ${ColErr}$(date -u) $errorGPUDriver ${NoColErr}
        exit 255
    fi

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
				  echo -e ${ColErr}$(date -u) $errorLinuxDist ${NoColErr}
				  exit 255
			   fi
			fi
       fi
    fi

Logging "########################################################################################################################"
Logging "# Zoneminder - Objekterkennung mit OpenCV, CUDA, cuDNN und YOLO auf Ubuntu $UBUNTU_VER                       By WIEGEHTKI.DE #"
Logging "# Zur freien Verwendung. Ohne Gewaehr und nur auf Testsystemen anzuwenden                                              #"
Logging "# For free use. Without warranty and to be used only on test systems                                                   #"
Logging "# V2.2.0 (Rev a), 12.02.2022                                                                                           #"
Logging "########################################################################################################################"
    UpdatePackages() {
        Logging "$installUpdate"
        apt-get -y update
        apt-get -y dist-upgrade
        Logging "UpdatePackages $infoStepEnd"
    }

    InstallGPUTools() {
        Logging "$installGPUTools"
        if [ "$UBUNTU_VER" == "18.04" ]; then
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
            if [ "$UBUNTU_VER" == "20.04" ]; then apt-get -y install nvtop; fi
            if [ "$UBUNTU_VER" == "21.10" ]; then apt-get -y install nvtop; fi
            if [ "$UBUNTU_VER" == "22.04" ]; then apt-get -y install nvtop; fi
        fi
        python3 -m pip install --upgrade --force-reinstall  glances[gpu]
        if [ -f /usr/local/bin/glances ]; then mv /usr/local/bin/glances /usr/bin/; fi
        Logging "$infoStepEnd"
    }

    InstallCuda() {
        Logging "$installCUDA"
        cd ~
        #apt -y install nvidia-cuda-toolkit
        git clone https://github.com/NVIDIA/cuda-samples.git
        cp ~/zoneminder/cuda_version.out ~/.
        chmod +x cuda_version.out
        ./cuda_version.out > ~/cuda.version

        if [ -f ~/cuda.version ]; then
            for i in ` sed s'/=/ /g' ~/cuda.version | awk '{print $1}' ` ;
                do
                export CUDA_VER=$i
                echo "CUDA_Version "$CUDA_VER | tee -a  ~/ExportControl.log
            done
        fi

        if [ "$CUDA_VER" == "NA" ]; then
           if ls cuda_* >/dev/null 2>&1; then rm -f ~/cuda_* &> /dev/null; fi
           if [ ! -f ~/$CUDA_Script ]; then wget $CUDA_DOWNLOAD; fi
           if [ -f ~/$CUDA_Script ]; then
              chmod +x $CUDA_Script
              ./$CUDA_Script --silent
              lshw -C display | tee -a  ~/FinalInstall.log
              #Pfade setzen
              echo $CUDA_SEARCH_PATH >> /etc/ld.so.conf
              ldconfig
              echo 'export PATH='$CUDA_SEARCH_PATH':'$PATH >> ~/.bashrc
              echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc
              echo 'LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
              export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
              export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
              echo 'cd ~' >> ~/.bashrc
              ln -s /usr/local/cuda-$CUDA_VERSION /usr/local/cuda
              source ~/.bashrc
              #apt-get -y install nvidia-cuda-toolkit
              Logging "$infoCompileCUDAExamples"
           else
              Logging "$CUDA_Script $errorDownload"
              echo " "
              echo $CUDA_Script $errorDownload
              return 1
           fi
        fi
       #else
       #   apt -y install nvidia-cuda-toolkit
       #   mkdir /usr/local/cuda
       #   mkdir /usr/local/cuda/bin
       #   ln -s /usr/local/cuda/bin/nvcc /usr/bin/nvcc
       #   mkdir /usr/local/cuda-$CUDA_VERSION
       #   ln -s /usr/local/cuda-$CUDA_VERSION /usr/local/cuda
       #fi

        cd ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery
        make -j$(nproc)
        cd ~
        if [ -f ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery ];  then
           ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery | tee -a  ~/FinalInstall.log
           ~/$CUDA_EXAMPLES_PATH/1_Utilities/deviceQuery/deviceQuery | grep "CUDA Capability Major/Minor version number:" >  ~/ComputeCapability.CUDA
           for i in ` sed s'/=/ /g' ~/ComputeCapability.CUDA | awk '{print $6}' `
               do
               export CUDA_COMPUTE_CAPABILITY=$i
               echo "CUDA_COMPUTE_CAPABILITY "$CUDA_COMPUTE_CAPABILITY | tee -a  ~/ExportControl.log
               awk -v "a=$CUDA_COMPUTE_CAPABILITY" -v "b=10" 'BEGIN {printf "%.0f\n", a*b}' > ~/ComputeCapability.FFMPEG
               done
        else
           Logging "$errorDeviceQuery"
           exit 255
        fi
        Logging "InstallCuda $infoStepEnd"
        return 0
    }

    InstallcuDNN() {
        Logging "$installcuDNN"
        local cuDNNFile
        cd ~
        if [ ! -f ~/$CUDNN_VERSION ]; then
            Logging "$errorcuDNN"
            echo " "
            echo $errorcuDNN
            return 1
        fi
        apt-get install zlib1g

        Logging "$infoStep1"^
        tar -xf $CUDNN_VERSION

        mv ~/$CUDNN_DIRECTORY   ~/cudnn
        #chmod a+r /usr/local/cuda-$CUDA_VERSION/cudnn

        cp -av cudnn/lib/libcudnn* /usr/local/cuda-$CUDA_VERSION/lib64
        cp -av cudnn/include/cudnn*.h /usr/local/cuda-$CUDA_VERSION/include
        cp -av cudnn/lib/libcudnn* /usr/local/cuda/lib64
        cp -av cudnn/include/cudnn*.h /usr/local/cuda/include

        chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
        chmod a+r /usr/local/cuda-$CUDA_VERSION/include/cudnn*.h /usr/local/cuda-$CUDA_VERSION/lib64/libcudnn*

        #cp $CUDNN_DIRECTORY/include/cudnn*.h /usr/local/cuda/include
        #cp -P $CUDNN_DIRECTORY/lib64/libcudnn* /usr/local/cuda/lib64
        #chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

        cd /usr/local/cuda/lib64
        if [ -f libcudnn.so ];   then rm libcudnn.so;   fi
        if [ -f libcudnn.so.8 ]; then rm libcudnn.so.8; fi
        ln libcudnn.so.$cuDNN_MajorVersion libcudnn.so.8
        ln libcudnn.so.8 libcudnn.so

        Logging "InstallcuDNN $infoStep2"
        cd  /usr/local/cuda-$CUDA_VERSION/targets/x86_64-linux/lib
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
        ln libcudnn_adv_infer.so.$cuDNN_MajorVersion libcudnn_adv_infer.so.8
        ln libcudnn_ops_train.so.$cuDNN_MajorVersion libcudnn_ops_train.so.8
        ln libcudnn_cnn_train.so.$cuDNN_MajorVersion libcudnn_cnn_train.so.8
        ln libcudnn_cnn_infer.so.$cuDNN_MajorVersion libcudnn_cnn_infer.so.8
        ln libcudnn_adv_train.so.$cuDNN_MajorVersion libcudnn_adv_train.so.8
        ln libcudnn_ops_infer.so.$cuDNN_MajorVersion libcudnn_ops_infer.so.8
        ln libcudnn_adv_infer.so.8 libcudnn_adv_infer.so
        ln libcudnn_ops_train.so.8 libcudnn_ops_train.so
        ln libcudnn_cnn_train.so.8 libcudnn_cnn_train.so
        ln libcudnn_cnn_infer.so.8 libcudnn_cnn_infer.so
        ln libcudnn_adv_train.so.8 libcudnn_adv_train.so
        ln libcudnn_ops_infer.so.8 libcudnn_ops_infer.so
        ldconfig
        source ~/.bashrc
        Logging "InstallcuDNN $infoStepEnd"
        return 0
    }

    SetUpMySQL() {
        Logging "$installMySQL"
        if [ $# -eq 0 ]; then
            Logging "SetUpMySQL $infoStep1"
            rm /etc/mysql/my.cnf
            cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf

            #echo "default-time-zone='+01:00'" >> /etc/mysql/my.cnf
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
        php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION.'';" > ~/php.version
        if [ -f ~/php.version ]; then
            FILESIZE=$(stat -c%s ~/php.version)
            if [ $FILESIZE -eq 0 ]; then
                export PHP_VERS="7.4"
            else
                for i in ` sed s'/=/ /g' ~/php.version | awk '{print $1}' ` ; do
                    PHP_VERS=$i
                    echo ${#PHP_VERS}
                done
            fi
        else
            export PHP_VERS="7.4"
        fi
        echo "PHP_VERS "$PHP_VERS | tee -a  ~/ExportControl.log

        if [ $PHP_VERS \< "7.0" ] || [ $PHP_VERS \> "7.9" ]; then
            ColErr="\033[1;31m"
            NoColErr="\033[0m"
            echo -e ${ColErr}$(date -u) $errorDetectPHP ${NoColErr}
            exit 255
        fi
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
            openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /etc/apache2/ssl/cert.crt -keyout /etc/apache2/ssl/cert.key -subj "/C=DE/ST=HE/L=Frankfurt/O=Zoneminder/OU=Zoneminder/CN=192.168.100.52"
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
      
        add-apt-repository -y ppa:iconnor/zoneminder-1.36
        export ZM_VERSION="1.36"
        
        apt update && sudo apt upgrade
        apt -y install zoneminder
        rm /etc/mysql/my.cnf  
        cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf
        echo "sql_mode        = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/my.cnf
        
        chmod 740 /etc/zm/zm.conf
        chown root:www-data /etc/zm/zm.conf
        chown -R www-data:www-data /usr/share/zoneminder/
        a2enmod cgi rewrite expires headers
        a2enconf zoneminder
        
        if [ -f /etc/php/*/cli/php.ini ]; then
            sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/*/cli/php.ini
        fi
        if [ -f /etc/php/*/apache2/php.ini ]; then
            sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/*/apache2/php.ini
        fi
        if [ -f /etc/php/*/fpm/php.ini ]; then
            sed -i "s|^;date.timezone =.*|date.timezone = ${TZ}|" /etc/php/*/fpm/php.ini
        fi
      
        Logging "InstallZoneminder $infoStep1"
        hostname -I > ~/ip.host
        
        cp ~/zoneminder/ini/*.ini /etc/zm/. -r
        chown www-data:www-data /etc/zm/*

        if [ -f ~/ip.host ]; then
            for i in ` sed s'/=/ /g' ~/ip.host | awk '{print $1}' ` ; do
                sed -i "s/<PORTAL-ADRESSE>/${i}/g" /etc/zm/secrets.ini
            done
        else
            ColErr="\033[1;31m"
            NoColErr="\033[0m"
            echo -e ${ColErr}$(date -u) $errorDetectIP ${NoColErr}
            exit 255
        fi
        
        Logging "$infoStep2"

        systemctl enable zoneminder
        start zoneminder
        systemctl reload apache2

        Logging "$infoStepEnd"
    }

    #EventServer installieren
    InstallEventserver() {
        Logging "$installEventServer"
        python3 -m pip install imutils
        
        cd ~
        
        git clone https://github.com/zoneminder/zmeventnotification.git
        cd ~/zmeventnotification
        # repeat these two steps each time you want to update to the latest stable
        git fetch --tags
        git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
        
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


        apt-get -y install liblwp-protocol-https-perl
        
        if [ -f ~/ip.host ]; then
            for i in ` sed s'/=/ /g' ~/ip.host | awk '{print $1}' ` ; do
                ES_IP=$i
            done
        else
            ColErr="\033[1;31m"
            NoColErr="\033[0m"
            echo -e ${ColErr}$(date -u) $errorDetectIP ${NoColErr}
            exit 255
        fi
        
        mkdir /etc/apache2/
        mkdir /etc/apache2/ssl/
        mv /root/zoneminder/apache/default-ssl.conf    /etc/apache2/sites-enabled/default-ssl.conf
        cp /etc/apache2/ports.conf                     /etc/apache2/ports.conf.default
        cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default

        openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /etc/apache2/ssl/cert.crt -keyout /etc/apache2/ssl/cert.key -subj "/C=DE/ST=HE/L=Frankfurt/O=Zoneminder/OU=Zoneminder/CN=$ES_IP"
        echo "$ES_IP" >> /etc/apache2/ssl/ServerName
        #echo "localhost" >> /etc/apache2/ssl/ServerName
        export SERVER=`cat /etc/apache2/ssl/ServerName`
        
        echo $SERVER
        (echo "ServerName" $SERVER && cat /etc/apache2/apache2.conf) > /etc/apache2/apache2.conf.old && mv  /etc/apache2/apache2.conf.old /etc/apache2/apache2.conf
        chown www-data:www-data /etc/apache2/ssl/*
                
        a2enmod ssl
        
        cd ~/zmeventnotification
        chmod -R +x *
        export INTERACTIVE="no"
        sudo -H yes | ./install.sh --install-es --install-hook --no-install-config --hook-config-upgrade --pysudo --download-models
        chmod +x /var/lib/zmeventnotification/bin/*
        yes | perl -MCPAN -e "install Config::IniFiles" #Fix

        chmod +x /var/lib/zmeventnotification/bin/*

        Logging "InstallEventserver $infoStep4"
        # Fix memory issue
        #Logging "$infoSharedMemory"
        #echo "Config" $SHMEM " - `awk '/MemTotal/ {print $2}' /proc/meminfo` bytes" | tee -a  ~/FinalInstall.log
        #umount /dev/shm
        #mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${SHMEM} tmpfs /dev/shm
        #chown -R www-data:www-data /etc/apache2/ssl/*
        #a2enmod ssl
        systemctl restart apache2
        Logging "InstallEventserver $infoStepEnd"
    }

    #Apache, MySQL, PHP
    InstallFaceRecognition() {
        Logging "$installFaceRecognition"
        if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("dlib"))'; then sudo -H pip uninstall dlib; fi
        if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("face-recognition"))'; then sudo -H pip uninstall face-recognition; fi
        Logging "InstallFaceRecognition $infoStep1"
        cd ~
        #git clone https://github.com/davisking/dlib.git
        #cd dlib
        #python3 -m setup.py install
        #cd ~
        #/zoneminder/dlib
        #python3 ./setup.py install
        #python3 -m pip install dlib
        python3 -m pip install face_recognition
        #cp -r ~/zoneminder/Bugfixes/face_train.py /usr/local/lib/python$PYTHON_VER/dist-packages/pyzm/ml/face_train.py
        Logging "InstallFaceRecognition $infoStepEnd"
    }

    InstallLAMP() {
        Logging "$installLAMP"
        apt-get -y install tasksel
        tasksel install lamp-server
        Logging "InstallLAMP $infoStepEnd"
    }

    InstallOpenCV() {
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
              -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules ~/opencv \
              -D HAVE_opencv_python3=ON \
              -D PYTHON_EXECUTABLE=/usr/bin/python3 \
              -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
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
            FILESIZE=$(stat -c%s ~/devices.cuda)
            if [ $FILESIZE -eq 0 ]; then
                ColErr="\033[1;31m"
                NoColErr="\033[0m"
                echo -e ${ColErr}$(date -u) $checkOpenCVCUDA ${NoColErr}
                exit 255
            else
                for i in ` sed s'/=/ /g' ~/devices.cuda | awk '{print $1}' ` ; do
                    if [ $i \> "0" ]; then Logging "$infoOpenCVCUDA"; else Logging "$errorOpenCVCUDA"; exit 255; fi
                done
            fi
        else
            ColErr="\033[1;31m"
            NoColErr="\033[0m"
            echo -e ${ColErr}$(date -u) $checkOpenCVCUDA ${NoColErr}
            exit 255
        fi
        Logging "InstallOpenCV $infoStepEnd"
    }

    InstallYOLO() {
        Logging "$installYOLO"
        apt-get -y install xrdp \
                   adduser xrdp ssl-cert
        systemctl restart xrdp

        #Disbale Power Management
        systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

        cd ~
        if [ -d ~/darknet ]; then
            Logging "$errorDarknetRepoExist"
            return 1
        else
            mv ~/zoneminder/darknet.repo ~/darknet
        fi

        Logging "InstallYOLO $infoStep1"
        (ls ~/darknet/YoloWeights >> /dev/null 2>&1 && echo "YoloWeights ok") || mkdir ~/darknet/YoloWeights
        (ls ~/darknet/YoloWeights/yolov4.weights >> /dev/null 2>&1 && echo "yolov4.weights ok") || echo "Download: yolov4.weights" && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT" -O ~/darknet/YoloWeights/yolov4.weights && rm -rf /tmp/cookies.txt
        (ls ~/darknet/YoloWeights/yolov3.weights >> /dev/null 2>&1 && echo "yolov3.weights ok") || echo "Download: yolov3.weights" && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A" -O ~/darknet/YoloWeights/yolov3.weights && rm -rf /tmp/cookies.txt
        (ls ~/darknet/YoloWeights/yolov3-tiny.weights >> /dev/null 2>&1 && echo "yolov3-tiny.weights ok") || echo "Download: yolov3-tiny.weights" && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt" -O ~/darknet/YoloWeights/yolov3-tiny.weights && rm -rf /tmp/cookies.txt

        cd ~/darknet/data
        if [ ! -f ~/darknet/data/darknet53.conv.74 ]; then wget https://pjreddie.com/media/files/darknet53.conv.74; fi

        Logging "InstallYOLO $infoStep2"
        cd ~/darknet
        make
        ([ $? -eq 0 ] && Logging "$infoMakeYOLO") || ( Logging "$errorMakeYOLO" && return 1 )
        Logging "InstallYOLO $infoStepEnd"
        return 0
    }

    InstallYOLO_mark() {
        Logging "$installYOLO_mark"
        if [ ! -d ~/darknet ]; then
            if [ -d ~/zoneminder/darknet.repo ]; then
                mv ~/zoneminder/darknet.repo ~/darknet
            else
                Logging "$errorDarknetRepoNotExist"
                return 1
            fi
        fi
        mv ~/darknet/mark ~/YOLO_mark
        chmod -R +x * ~/YOLO_mark
        cd ~/YOLO_mark
        Logging "InstallYOLO_mark $infoStep1"
        cmake .
        Logging "InstallYOLO_mark $infoStep2"
        make
        ([ $? -eq 0 ] && Logging "$infoMakeYOLO_mark") || ( Logging "$errorMakeYOLO_mark" && return 1 )
        Logging "InstallYOLO_mark $infoStepEnd"
        return 0
    }

    InstallLibs() {
        Logging "$installLibs"
        sudo apt-get update
        sudo apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
        libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
        libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev libopus-dev
        Logging "InstallLibs $infoStepEnd"
    }

    #Install nvidia SDK
    InstallSDK() {
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
    CompileNasm() {
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
    CompileLibX264() {
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
    CompileLibfdkacc() {
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
    CompileLibMP3Lame() {
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
    CompileLibOpus() {
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
    CompileLibX265() {
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
    CompileLibPvx() {
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
    CompileFfmpeg() {
        Logging "$installFFMPEG"
        cd ~
        git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
        cd ~/nv-codec-headers/
        Logging "CompileFfmpeg $infoStep1"
        make install
        cd ~
        Logging "CompileFfmpeg $infoStep2"
        git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg_sources/
        cd ~/ffmpeg_sources
        Logging "CompileFfmpeg $infoStep3"
        if [ -f ~/ffmpeg_sources/configure ]; then
            if [ -f ~/ComputeCapability.FFMPEG ]; then
                for i in ` sed s'/=/ /g' ~/ComputeCapability.FFMPEG | awk '{print $1}' ` ; do
                    export COMPUTE_COMP=$i
                done
                sed -i "s/compute_30,code=sm_30/compute_$COMPUTE_COMP,code=sm_$COMPUTE_COMP/g" ~/ffmpeg_sources/configure
                sed -i "s/cuda-gpu-arch=sm_30/cuda-gpu-arch=sm_${COMPUTE_COMP}/g" ~/ffmpeg_sources/configure
            fi
        fi
        ./configure --enable-nonfree --enable-cuda-nvcc --enable-cuda --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64
        make -j$(nproc)
        Logging "CompileFfmpeg $infoStep4"
        make install
        if [ -f /usr/local/bin/ffmpeg ]; then mv /usr/local/bin/ffmpeg /usr/bin/ffmpeg; fi
        #if [ -f /usr/local/bin/ffmpeg ]; then cp /usr/local/bin/ffmpeg /usr/share/ffmpeg; fi

        Logging "CompileFfmpeg $infoStepEnd"
    }


    #./configure --enable-cuda \
    #             --enable-cuvid \
    #             --enable-nvenc \
    #             --enable-nonfree \
    #             --enable-libnpp \
    #             --enable-opengl \
    #             --enable-vaapi \
    #             --enable-vdpau \
    #             --enable-libvorbis \
    #             --enable-libmp3lame \
    #             --enable-libx264 \
    #             --enable-libx265 \
    #             --enable-gpl

    #Bugfixing und Finalisierung
    BugFixes_Init() {
        Logging "$installBugfixes"
        python3 -m pip install protobuf==3.19.1
        #3.3.0
        #python3 -m pip install numpy==1.17
        #16.5

        yes | perl -MCPAN -e "upgrade IO::Socket::SSL"
        cd ~
        zmupdate.pl -f


        export PYTHONPATH=/usr/local/lib/python'$PYTHON_VER'/site-packages:/usr/local/lib/python'$PYTHON_VER'/site-packages/cv2/python-'$PYTHON_VER':$PYTHONPATH
        sed -i '2 i export PYTHONPATH='$PYTHONPATH /var/lib/zmeventnotification/bin/zm_event_end.sh
        sed -i '2 i export PYTHONPATH='$PYTHONPATH /var/lib/zmeventnotification/bin/zm_event_start.sh
        
        if [ $PYTHON_VER \== "3.8" ]; then
            if [ $ZM_VERSION \== "1.36" ]; then
               cp -r ~/zoneminder/Bugfixes/yolo.py /usr/local/lib/python$PYTHON_VER/dist-packages/pyzm/ml/yolo.py
            fi
        fi
 
        Logging "BugFixes_Init $infoStepEnd"
    }

    Logging "Main $infoStartInstallation"
    echo ""
    ColImp="\033[1;32m"
    NoColImp="\033[0m"

    echo -e "${ColImp}$infoZMVersion ${NoColImp}$1"
    echo ""
    #echo -e "${ColImp}$infoZMSelect ${NoColImp}$1"

    #read -rsn1 input
    #if [ "$input" = "1" ]; then export ZM_VERSION="1.34"; add-apt-repository -y ppa:iconnor/zoneminder-1.34; else add-apt-repository -y ppa:iconnor/zoneminder-master; export ZM_VERSION="1.35"; fi
    #add-apt-repository ppa:iconnor/zoneminder-1.36
    #add-apt-repository -y ppa:iconnor/zoneminder-master
    export ZM_VERSION="1.36"

    #VERSION = "1.34"
    #    [[ "$ZM_VERSION" == "$VERSION" ]] && add-apt-repository -y ppa:iconnor/zoneminder-1.34 || add-apt-repository -y ppa:iconnor/zoneminder-master

    if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
       echo "Setzen der Zeitzone auf: $TZ"
       echo $TZ > /etc/timezone
       ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
       dpkg-reconfigure tzdata -f noninteractive
       #echo "Datum: `date`"
    fi
    if InstallCuda $1;  then echo "InstallCuda ok"  | tee -a  ~/FinalInstall.log; else ColErr="\033[1;31m"; NoColErr="\033[0m"; echo -e ${ColErr}$(date -u) $errorCUDAInstall ${NoColErr}; exit 255; fi
    if InstallcuDNN $1; then echo "InstallcuDNN ok" | tee -a  ~/FinalInstall.log; else ColErr="\033[1;31m"; NoColErr="\033[0m"; echo -e ${ColErr}$(date -u) $errorcuDNNInstall ${NoColErr}; exit 255; fi
    UpdatePackages
    InstallLamp
    #SetUpPHP
    InstallZoneminder
    InstallEventserver
    #BugFixes_Init
    InstallFaceRecognition
    #AccessRightsZoneminder
    InstallOpenCV
    #BugFixes_Init
    #AccessRightsZoneminder
    #if [ "$UBUNTU_VER" == "20.04" ]; then CompileFfmpeg; fi
    InstallGPUTools
    if InstallYOLO $1; then echo "Installation YOLO ok" | tee -a  ~/FinalInstall.log; else ColErr="\033[1;31m"; NoColErr="\033[0m"; echo -e ${ColErr}$(date -u) $errorMakeYOLO ${NoColErr}; exit 255; fi
    if InstallYOLO_mark $1; then echo "Installation YOLO_mark ok" | tee -a  ~/FinalInstall.log; else ColErr="\033[1;31m"; NoColErr="\033[0m"; echo -e ${ColErr}$(date -u) $errorMakeYOLO_mark ${NoColErr}; exit 255; fi
    Logging "Main $infoEndofInstallation"
    read -rsn1 input
    reboot

    # cd ~
    # mkdir ffmpeg_sources
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

    #Test Chromebrowser:
    #https://zm.wiegehtki.de/zm/api/host/getVersion.json
    #https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=snapshot
    #https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=alarm

    #/var/lib/zmeventnotification/known_faces
    #sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
    #sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid 1 --monitorid 1 --debug
    #chown -R www-data:www-data /var/lib/zmeventnotification/known_faces
    #echo "zm.wiegehtki.de" >> /etc/hosts

    #rtmp://192.168.100.164/bcs/channel0_main.bcs?channel=0&stream=0&user=admin&password=<Dein Passwort>
