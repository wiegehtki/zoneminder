# zoneminder object detection mit yolo by Udo Würtz, WIEGEHTKI.DE
# Kameraüberwachung mit Objekterkennung mittels Zoneminder, YOLO und OpenCV
### KOMMT IN KÜRZE; NOCH IM TEST
### Installation von Zoneminder 1.35.x, OpenCV 4.5 und YOLO (Tiny, v3 und v4) unter Ubuntu 18.04 LTS
### Unterstützt NVIDIA® GPU's unter x86 Ubuntu (Workstation)

#### Nach der Installation dieser Software könnt Ihr:
* Mit Zoneminder Eure IP-Kameras einbinden und mobil verfügbar machen
* Den Livestream mit OpenCV und YOLO auf Objekte untersuchen
* Erkannte Objekte, z.B. Personen, zuverlässig melden lassen
* Personen trainieren (Achtung: Datenschutzgesetz beachten!)
*
* Dokument zu Yolo(v4): https://arxiv.org/abs/2004.10934
* Infos zum Darknet framework: http://pjreddie.com/darknet/
* Infos zu OpenCV findet Ihr hier: https://opencv.org/


#### Videos zu diesem Projekt (und weitere) findet Ihr auf https://wiegehtki.de
* **Intro:** https://www.youtube.com/watch?v=_ndzsZ66SLQ
* **Basiswissen Objekterkennung mit YOLO:** https://www.youtube.com/watch?v=WXuqsRGIyg4&t=1586s
* **Technologischer Deep Dive in YOLO:** https://www.youtube.com/watch?v=KMg6BwNDqBY

#### Zur Installation könnt ihr wie folgt vorgehen, dazu alle Befehle im Terminal ausführen:

1.  Ubuntu 18.04 LTS installieren
2.  Einloggen und dann die erste Stufe der Installation starten, der Rechner rebootet danach automatisch:
```
       sudo su
	   cd ~
       git clone https://github.com/wiegehtki/zoneminder.git
       cp zoneminder/*sh .
       sudo chmod +x *sh
       ./Initial.sh      
```

#### Bevor wir weitermachen können, müssen im Verzeichnis `~/Anzupassen` verschiedene Dateien modifiziert werden.
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
**Nur bei Bedarf** den Eintrag anpassen, dazu einfach die **#** vor die Zeile setzen, welche inaktviert werden soll und dort entfernen, welche Zeilen aktiviert werden sollen. Der Standard sieht wie folgt aus:
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
        -D WITH_CUBLAS=1 \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
        -D HAVE_opencv_python3=ON \
        -D PYTHON_EXECUTABLE=/usr/bin/python3 \
        -D PYTHON2_EXECUTABLE=/usr/bin/python2 \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D BUILD_EXAMPLES=OFF ..
```
Entscheidend ist der Eintrag `-D CUDA_ARCH_BIN=6.1`, genau genommen der Wert `6.1` Dieser **MUSS** an die vorhandene Grafikkarte angepasst werden und repräsentiert die sogenannte **Compute capability version**. Dazu die Site **https://en.wikipedia.org/wiki/CUDA** öffnen und die jeweilige Grafikkarte in der Tabelle suchen. Der benötigte Wert steht ganz links in der Spalte. Für die im Test verwendetet GTX 1070 beträgt dieser 6.1, bei einer V100 7.0. Bitte diesen Wert auf den für Eure Grafikkarte angegebenen ändern!



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


