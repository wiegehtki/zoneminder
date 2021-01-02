sudo apt -y upgrade
sudo apt -y dist-upgrade

sudo apt-get install tasksel
sudo tasksel install lamp-server
sudo -i

add-apt-repository ppa:iconnor/zoneminder-1.34
apt-get update
apt-get upgrade
apt-get dist-upgrade

apt -y install python3-pip cmake
apt -y install libopenblas-dev liblapack-dev libblas-dev
			 

#Mysql
rm /etc/mysql/my.cnf  
cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf

nano /etc/mysql/my.cnf
#In mysqkd - Sektion folgendes einfügen:
sql_mode = NO_ENGINE_SUBSTITUTION 

systemctl restart mysql
apt-get -y install zoneminder
sudo apt -y install ntp

mysql -uroot -p < /usr/share/zoneminder/db/zm_create.sql
mysql -uroot -p -e "grant lock tables,alter,drop,select,insert,update,delete,create,index,alter routine,create routine, trigger,execute on zm.* to 'zmuser'@localhost identified by 'zmpass';"

chmod 740 /etc/zm/zm.conf
chown root:www-data /etc/zm/zm.conf
chown -R www-data:www-data /usr/share/zoneminder/

a2enmod cgi
a2enmod rewrite
a2enconf zoneminder
a2enmod expires
a2enmod headers

systemctl enable zoneminder
systemctl start zoneminder

nano /etc/php/7.2/apache2/php.ini
nano /etc/php/7.2/cli/php.ini
## Nachfolgende Timezone anpassen ##
[Date]
; Defines the default timezone used by the date functions
; http://php.net/date.timezone
date.timezone = Europe/Berlin
sudo timedatectl set-timezone Europe/Berlin

git clone https://github.com/pliablepixels/zmeventnotification.git
cd zmeventnotification
git fetch --tags
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

##ANpassen! Thema SHell...
sudo perl -MCPAN -e "install Crypt::MySQL"
sudo perl -MCPAN -e "install Config::IniFiles"
sudo perl -MCPAN -e "install Crypt::Eksblowfish::Bcrypt"

sudo apt-get -y install libyaml-perl
sudo apt-get -y install make
sudo perl -MCPAN -e "install Net::WebSocket::Server"

sudo apt-get -y install libjson-perl
perl -MCPAN -e "install LWP::Protocol::https"
perl -MCPAN -e "install Net::MQTT::Simple"

#MySql
default-time-zone='+01:00'


##Apache2
mkdir /etc/apache2/ssl/
mkdir /etc/zm/apache2/
mkdir /etc/zm/apache2/ssl/
mv /root/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
cp /etc/apache2/ports.conf /etc/apache2/ports.conf.default
cp /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf.default

##Server name muss noch rein ....
/etc/apache2/apache2.conf
#Erste Linie:
ServerName zm.wiegehtki.de

#Und in etc/hosts:
192.168.100.245 zm.wiegehtki.de

# FIX: Opt Auth enablen und dann disablen um die DB Connections zu beruhigen

	 
# Face recognition
sudo -H pip3 uninstall dlib
sudo -H pip3 uninstall face-recognition
sudo apt-get -y install libopenblas-dev liblapack-dev libblas-dev # this is the important part
sudo -H pip3 install dlib --verbose --no-cache-dir # make sure it finds openblas
sudo -H pip3 install face_recognition


#CUDNN installieren
# Download
tar -xzvf cudnn-10.1-linux-x64-v8.0.5.39.tgz
sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

#opencv compilieren
OPENCV_VER=4.4.0
OPENCV_URL=https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
OPENCV_CONTRIB_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip

cd ~
wget  -O opencv.zip $OPENCV_URL
wget  -O opencv_contrib.zip $OPENCV_CONTRIB_URL
unzip opencv.zip
unzip opencv_contrib.zip
mv $(ls -d opencv-*) opencv
mv opencv_contrib-$OPENCV_VER opencv_contrib
#rm *.zip

#logger "Compiling opencv..." -tEventServer

cd ~/opencv
rm -rf build
mkdir build
cd build

#Wichtig: Je nach Karte wählen - CUDA_ARCH_BIN = https://en.wikipedia.org/wiki/CUDA 


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

make -j$(nproc)

#logger "Installing opencv..." -tEventServer
make install

# Test auf CUDA enabled Devices, muss größer 0 sein:
import cv2
count = cv2.cuda.getCudaEnabledDeviceCount()
print(count)

/usr/local/lib/python3.6/dist-packages/cv2
rm /usr/bin/python
ln -sf python3.6 /usr/bin/python

Modify  num_jitters = int(self.options.get('face_num_jitters'),0) in  /usr/local/lib/python3.6/dist-packages/pyzm/ml/face_train.py
auf num_jitters = self.options.get('face_num_jitters')


	Unrecoverable error:int() can't convert non-string with explicit base Traceback:Traceback (most recent call last): File "/var/lib/zmeventnotification/bin/zm_detect.py", line 858, in <module> main_handler() File "/var/lib/zmeventnotification/bin/zm_detect.py", line 346, in main_handler model=g.config['face_model']) File "/usr/local/lib/python3.6/dist-packages/pyzm/ml/face.py", line 92, in __init__ train.FaceTrain(options=self.options).train() File "/usr/local/lib/python3.6/dist-packages/pyzm/ml/face_train.py", line 35, in train num_jitters = int(self.options.get('face_num_jitters'),0)TypeError: int() 	
