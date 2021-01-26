# Kameraüberwachung mit Objekt- und Gesichtserkennung mittels Zoneminder, YOLO und OpenCV auf x86 - Plattformen, benötigt NVIDIA® - GPU mit CUDA® und cuDNN®
### Installation von Zoneminder 1.34.x, OpenCV 4.5.1 und YOLO (Tiny, v3 und v4) unter Ubuntu 18.04 LTS


#### Nach der Installation dieser Software könnt Ihr:
* Mit Zoneminder Eure IP-Kameras einbinden und mobil verfügbar machen
* Den Livestream mit OpenCV und YOLO auf Objekte untersuchen
* Erkannte Objekte, z.B. Personen, zuverlässig melden lassen
* Gesichter trainieren (Achtung: Datenschutzgesetz beachten!)
* Dokument zu Yolo(v4): https://arxiv.org/abs/2004.10934
* Infos zum Darknet framework: http://pjreddie.com/darknet/
* Infos zu OpenCV findet Ihr hier: https://opencv.org/


#### Videos zu diesem Projekt (und weitere) findet Ihr auf https://wiegehtki.de
* **Einführung in das Projekt:** https://youtu.be/TsEwtInBl3c
* **Installation des Betriebssystems:** https://youtu.be/_P9d5rERbBA
* **Installation der Software:** https://youtu.be/9pQ3ouCPqm8
* **Inbetriebnahme:** https://youtu.be/3yM87yOXaBs


#### Aufsetzen des Systems:
Benötigt wird eine Ubuntu 18.04 LTS Umgebung. Ihr solltet eine Maschine explizit und nur dafür vorsehen (virtuell oder physisch) welche NICHT im produktiven Einsatz ist! Das System wird durch die nachfolgenden Schritte erheblich verändert und daher solltet Ihr dies ausschließlich auf dafür eiegns bereitgestellten Test-Systemen durchführen.

Ihr könnt den Ubuntu Server unter https://releases.ubuntu.com/18.04/ runter laden. Anschließend das Image auf einen USB-Stick übertragen, zum Beispiel mit balenaEtcher (https://www.balena.io/etcher/) oder einem anderem Tool welches dafür geeignet ist.

Unter WIEGEHTKI.DE (https://www.youtube.com/channel/UC_OeEKyvDfCVdhYrEKYf1lA) findet Ihr den Video zur Installation


#### Notwendige Schritte VOR der weiteren Installation:
In diesem Projekt kommt eine NVIDIA® Grafikkarte zum Einsatz um den Prozessor von rechenintensiven Verarbeitungen zu befreien. Dazu setzen wir NVIDIA®'s CUDA® und cuDNN® ein. CUDA® ist eine Technologie, die es erlaubt Programmteile durch den Grafikprozessor abarbeiten zu lassen während die NVIDIA® CUDA® Deep Neural Network Bibliothek (cuDNN) eine GPU-beschleunigte Bibliothek mit Primitiven für tiefe neuronale Netzwerke darstellt. Solche Primitive, typischerweise neuronale Netzwerkschichten genannt, sind die grundlegenden Bausteine tiefer Netzwerke.

cuDNN® ist insofern nicht frei verfügbar als dass man sich bei NVIDIA® registrieren muss. Das ist aktuell kostenlos, nach der Registrierung startet eine sehr kurze Umfrage, wozu man das einsetzt und dann kommt man auf die Download-Site.

1. Der Link zur Registrierung: https://developer.nvidia.com/CUDNN. Dort auf **Download cuDNN** klicken und anschließend registrieren.
2. Nach erfolgreicher Reistrierung bitte in der Sektion **Download cuDNN v8.0.5 (November 9th, 2020), for CUDA 10.2** (das kann sich natürlich ggfs. ändern und etwas anders heißen) unter **Library for Linux, Ubuntu(x86_64 & PPC architecture)** die Datei **cuDNN Library for Linux (x86)** runter laden; **NICHT die Ubuntu-Dateien!** 
3. Die Datei per `scp` oder einem entsprechenden Tool direkt in das `/root/` - Verzeichnis kopieren.
4. Auf der Maschine anmelden und folgende Schritte ausführen, wobei `sudo su` nicht notwendig ist, wenn Ihr bereits **root** sein solltet.
```
       sudo su
       cd ~
       sudo chmod +x cudnn*     
```
Anschließend kommen wir zur eigentlichen Installation des Systems. Diese ist in zwei Stufen unterteilt: In Stufe 1 installieren wir einige Standard-Pakete und de-aktivieren den bisherigen Grafiktreiber, anschließend startet das System neu. Der Script geht davon aus, dass es sich um eine neu aufgesetzte Maschine handelt, falls nicht, müsst Ihr entsprechende Anpassungen machen oder die Befehle per Hand ausführen um sicher zu gehen, dass eine vorhandene Installation nicht beeinträchtigt wird. Empfohlen wird daher, ein verfügbares Testsystem zu nutzen welches neu aufgesetzt werden kann.

#### Zur Installation könnt ihr wie folgt vorgehen, dazu alle Befehle im Terminal ausführen:
Einloggen und dann die erste Stufe der Installation starten, der Rechner rebootet danach automatisch:
```
       sudo su
       cd ~
       git clone https://github.com/wiegehtki/zoneminder.git
       cp zoneminder/*sh .
       sudo chmod +x *sh
       ./Initial.sh      
```

#### Bevor wir weitermachen können, müssen im Verzeichnis `~/zoneminder/Anzupassen` verschiedene Dateien modifiziert werden.
* **Ohne diese Anpassungen wird die Installation nicht funktionieren. Daher ist dieser Schritt besonders sorgfältig durchzuführen.**

1. **secrets.ini:**  Zunächst einloggen, in das /root - Verzeichnis wechseln und die erste Datei mit dem Editor öffnen.
```
       sudo su
       cd ~
       nano ~/zoneminder/Anpassungen/secrets.ini
```
Anschließend folgende Einträge anpassen:
`ZMES_PICTURE_URL=https://<PORTAL-ADRESSE>/zm/index.php?view=image&eid=EVENTID&fid=objdetect&width=600` Hier den Eintrag **<PORTAL-ADRESSE>** anpassen. Es sollte idealerweise eine "echte" Adresse sein, zum Beispiel bei mir war das: zm.wiegehtki.de und muss natürlich bei Euch an das jeweilige Portal angepasst werden.
Wenn gar keine echte Adresse zur Verfügung steht, dann eine erfinden und im Client zum Test in der `hosts` - Datei eintragen und den Eintrag von `https` auf http` ändern.

Das gleiche gilt für `ZM_PORTAL=https://<PORTAL-ADRESSE>/zm` und `ZM_API_PORTAL=https://<PORTAL-ADRESSE>/zm/api`. Anschließend die Datei mit `STRG + O` speichern und den Editor mit `STRG + X` beenden. Die anderen Parameter können erstmal ignoriert werden und müssen nicht angepasst werden.


2. **objectconfig.ini:**  Diese Datei muss nur dann angepasst werden, wenn das vor-trainierte Model gewechselt werden soll. Ich habe hier **yolov4** mit *GPU*-Unterstützung vor- eingestellt. Sollte man KEINE GPU zur Unterstützung zur Verfügung haben, kann der entsprechende Eintrag notfalls auch auf **CPU** geändert werden.  
```
       nano ~/zoneminder/Anpassungen/objectconfig.ini
```
**Nur bei Bedarf** Wenn Ihr ein anderes Framework/Model nutzen wollt,könnt Ihr den dazugehörigen Eintrag anpassen. Dazu einfach ein **#** vor die Zeile setzen, welche inaktviert werden soll bzw. entfernen, wenn Zeilen aktiviert werden sollen. Die Vorgabe von mir sieht wie folgt aus:
```
       # FOR YoloV4. 
       object_framework=opencv
       object_processor=gpu 
       # object_processor=cpu
       object_config={{base_data_path}}/models/yolov4/yolov4.cfg
       object_weights={{base_data_path}}/models/yolov4/yolov4.weights
       object_labels={{base_data_path}}/models/yolov4/coco.names
```

3. **OpenCV - Anpassung der Grafikkarte**. Dieser Schritt ist sehr wichtig da ansonsten die Grafikkarte von OpenCV nicht angesprochen werden kann und keine Objekterkennung durchgeführt wird.

Dazu die Datei **Final.sh** im Editor öffnen und folgenden Eintrag suchen:
```
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
        -D BUILD_EXAMPLES=OFF ..
```
Entscheidend ist der Eintrag `-D CUDA_ARCH_BIN=6.1` und `-D CUDA_ARCH_PTX=6.1 \`, genau genommen der Wert `6.1` Dieser **MUSS** an die vorhandene Grafikkarte angepasst werden und repräsentiert die sogenannte **Compute capability version**. Dazu die Site **https://en.wikipedia.org/wiki/CUDA** öffnen und die jeweilige Grafikkarte in der Tabelle suchen. Der benötigte Wert steht ganz links in der Spalte. Für die im Test verwendetet GTX 1070 beträgt dieser 6.1, bei einer V100 7.0. Bitte diesen Wert auf den für Eure Grafikkarte angegebenen ändern!



**Wichtig:** Der Installationsprozess ist in 2 Schritte unterteilt, **Initial.sh** und **Final.sh** und erfordert ein paar Betsätigungen durch den Benutzer.
3.  Erneut Einloggen und dann die zweite und letzte Stufe der Installation starten:
```
       sudo su
	   cd ~
       ./Final.sh  
```


#### Kontrolle des Installationsfortschritts

Ein weiteres Terminalfenster öffnen und mit `cat Installation.log` bzw. `cat FinalInstall.log` den Fortschritt der Installationen kontrollieren.
   
Nach der Installation einen `reboot` ausführen.
  
Die **.weights - Dateien** sollten über den Installationsscript geladen werden.
Falls nicht, hier die Download-Links:

1. Download yolov3.weights: https://drive.google.com/file/d/10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A/view?usp=sharing
2. Download yolov3-tiny.weights: https://drive.google.com/file/d/12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt/view?usp=sharing
3. Download yolov4.weights: https://drive.google.com/file/d/1Z-n8nPO8F-QfdRUFvzuSgUjgEDkym0iW/view?usp=sharing

### Optimierungen

### Bekannte Fehler und deren Behebungen
1. **Datenbank-Verbindungen werden immer mehr und die Verbindung zur Datenbank geht verloren** 
   Wenn dieser Fehler auftritt (gesehen bei **Zoneminder 1.34.22**), dann folgende Schritte durchführen:
	* Rechner rebooten
	* ZM-Site aufrufen
	* `Options->Users` aufrufen und dem `admin` - Benutzer ein Kennwort vergeben
	* `Options->System` anwählen und `OPT_USE_AUTH` aktivieren
	* Ganz unten `Save` anklicken und Einstellungen speichern
	* `Options->System` anwählen und `OPT_USE_AUTH` **de-aktivieren**
	* `AUTH_RELAY` auf **none** setzen
	* `AUTH_HASH_SECRET` auf irgendeinen Wert setzen
	* Wieder `Save` anklicken und Einstellungen speichern
	
	Der Fehler sollte jetzt nicht mehr auftreten.

2. **Beim Aufruf eines Installationsscripts kommt die Fehlermeldung `/usr/bin/env: ‘bash\r’: No such file or directory`** 
   Wenn dieser Fehler auftritt, dann folgende Schritte durchführen:
	* sed $'s/\r$//' -Script bei dem der Fehler auftriit, z.B. Initial.sh- > -Neues Script, z.B. InitialNeu.sh-
	* chmod +x *
	* Aufruf des neuen Scripts, z.B.: ./InitialNeu.sh


