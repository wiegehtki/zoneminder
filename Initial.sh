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
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "01 von 04: Hardware und Linux - Check"  | tee -a  ~/Installation.log
                lshw -C display | tee -a  ~/Installation.log
                uname -m && cat /etc/*release | tee -a  ~/Installation.log
				
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "02 von 04: System - Update & Upgrade"  | tee -a  ~/Installation.log
                apt -y update
                apt -y dist-upgrade
				
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "03 von 04 Diverse Pakete installieren wie Compiler, Headers usw., welche für CUDA benötigt werden"  | tee -a  ~/Installation.log
                apt -y install linux-headers-$(uname -r)
                apt -y install gcc make nano

echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "04 von 04: Nouveau - Grafiktreiber ausschaltenm und reboot"  | tee -a  ~/Installation.log
                sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
                sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
                update-initramfs -u

                reboot

