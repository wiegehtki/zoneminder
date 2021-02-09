#!/usr/bin/env bash

Benutzer="root" 
Language="German"
    
if [ $Language = "German" ]; then
    declare -r errorUser="Script muss als Benutzer: $Benutzer ausgeführt werden!"
    declare -r errorLinuxDistribution="Keine gültige Distribution, Installer wird beendet"
else
    declare -r errorUser="Script must be executed as user: $Benutzer !"
    declare -r errorLinuxDistribution="No valid distribution, installer exits"
fi

if [ "$(whoami)" != $Benutzer ]; then
    echo $(date -u) $errorUser
    exit 255
fi
Logging() {
    echo $(date -u) "$1"  | tee -a  ~/Training.log
}
export LINUX_VERSION_NAME=`lsb_release -sr`

if [[ ${LINUX_VERSION_NAME} == "18.04" ]]; then
    export UBUNTU_VER="18.04"
else
    if [[ ${LINUX_VERSION_NAME} == "20.04" ]]; then
        export UBUNTU_VER="20.04"
    else
        echo " "
        echo "$errorLinuxDistribution"
        exit
    fi
fi

Logging "#####################################################################################################################################"
Logging "# Zoneminder - Objekterkennung mit OpenCV und YOLO. Support für Ubuntu $UBUNTU_VER                                        By WIEGEHTKI.DE #"
Logging "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                                            #"
Logging "#                                                                                                                                   #"
Logging "# v2.0.1 (Rev a), 07.02.2021                                                                                                        #"
Logging "#####################################################################################################################################"
Logging "....................................................................................................................................."

        chown -R www-data:www-data /var/lib/zmeventnotification/known_faces
        sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
                 