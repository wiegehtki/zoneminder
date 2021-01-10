#!/usr/bin/env bash

echo $(date -u) "########################################################################################################################" | tee -a  ~/FinalInstall.log
echo $(date -u) "# Zoneminder - Objekterkennung mit OpenCV, CUDA, cuDNN und YOLO auf Ubuntu 18.04 LTS                   By WIEGEHTKI.DE #" | tee -a  ~/FinalInstall.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                               #" | tee -a  ~/FinalInstall.log
echo $(date -u) "#                                                                                                                      #" | tee -a  ~/FinalInstall.log
echo $(date -u) "# V1.0.0 (Rev a), 10.01.2021, Aufruf des Gesichtstrainings                                                             #" | tee -a  ~/FinalInstall.log
echo $(date -u) "########################################################################################################################" | tee -a  ~/FinalInstall.log

                 sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py
                 chown -R www-data:www-data /var/lib/zmeventnotification/known_faces