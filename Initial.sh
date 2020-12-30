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
                apt -y install gcc make nano letsencrypt
				apt -y install build-essential cmake pkg-config unzip yasm git checkinstall
				apt -y install libjpeg-dev libpng-dev libtiff-dev
				apt -y install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev
				apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
				apt -y install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev
				apt -y install libfaac-dev libmp3lame-dev libvorbis-dev
				apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
				apt -y install libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils
                cd /usr/include/linux
                ln -s -f ../libv4l1-videodev.h videodev.h
                cd ~
				apt -y install install libgtk-3-dev
				apt -y install python3-testresources
				apt -y install libtbb-dev
				apt -y install libatlas-base-dev gfortran
				apt -y install libprotobuf-dev protobuf-compiler
				apt -y install libgoogle-glog-dev libgflags-dev
				apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
				apt -y install gcc-6
				
				cd ~
                wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.0.zip
                wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.0.zip
				unzip opencv.zip
                unzip opencv_contrib.zip
				unzip opencv.zip
                mv opencv-4.5.0 opencv
                mv opencv_contrib-4.5.0 opencv_contrib
                cd opencv
                rm -rf build
                mkdir build
                cd build
				
				6.6 10:20
				25.6 16:10
				VBXJ29
				
				tar -xzvf ${CUDNN_TAR_FILE}


# copy the following files into the cuda toolkit directory.
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-10.1/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-10.1/lib64/
sudo chmod a+r /usr/local/cuda-10.1/lib64/libcudnn*
				
                export CFLAGS=$CFLAGS" -w"
                export CPPFLAGS=$CPPFLAGS" -w"
                export CXXFLAGS=$CXXFLAGS" -w"

                cmake	-D CMAKE_BUILD_TYPE=RELEASE \
                        -D OPENCV_GENERATE_PKGCONFIG=YES \
                        -D WITH_CUDA=ON \
                        -D CUDA_ARCH_PTX="" \
                        -D WITH_CUBLAS=1 \
						-D ENABLE_FAST_MATH=1 \
                        -D CUDA_FAST_MATH=1 \
                        -D WITH_LIBV4L=ON \
                        -D BUILD_opencv_python3=ON \
                        -D BUILD_opencv_python2=OFF \
                        -D BUILD_opencv_java=OFF \
						-D WITH_QT=OFF \
                        -D WITH_GSTREAMER=ON \
                        -D WITH_GTK=ON \
                        -D BUILD_TESTS=OFF \
                        -D BUILD_PERF_TESTS=OFF \
                        -D BUILD_EXAMPLES=OFF \
                        -D OPENCV_ENABLE_NONFREE=ON \
                        -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-4.5.0/modules .. \
                        -Wno-deprecated-gpu-targets						

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
-D PYTHON_EXECUTABLE=~/usr/bin \
-D BUILD_EXAMPLES=ON . \
-Wno-deprecated-gpu-targets	


  75  sudo -u www-data ls -la /root
   76  nano /etc/zm/objectconfig.ini
   77  sudo -u www-data ls -la /var/lib/zmeventnotification/
   78  sudo -u www-data ls -la /var/lib/zmeventnotification/known_faces
   79  sudo -u www-data ls -la /var/lib/zmeventnotification/unknown_faces
   80  reboot
   81  cat /config/opencv/opencv.sh
   82  ls
   83  find / -name opencv_compile.sh
   84  cat /etc/init.d/zoneminder/defaults/opencv_compile.sh
   85  ls
   86  cd /home/uwuertz/
   87  ls
   88  chmod +x *
   89  dpkg -i libcudnn8-dev_8.0.5.39-1+cuda11.1_arm64.deb
   90  dpkg -i libcudnn8-dev_8.0.5.39-1+cuda11.1_amd64.deb
   91  sudo dpkg -i libcudnn8_8.0.5.39-1+cuda11.1_amd64.deb
   92  ls /usr/local/cuda
   93  sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
   94  find / -name cudnn*.h
   95  sudo cp /usr/include/x86_64-linux-gnu/cudnn*.h /usr/local/cuda/include
   96  find / -name libcudnn*.h
   97  find / -name libcudnn*
   98  find / -name libcudnn
   99  ls /usr/include/x86_64-linux-gnu/
  100  sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
  101  find / -name libcudnn*
  102  sudo dpkg -i libcudnn8_8.0.5.39-1+cuda11.1_amd64.deb
  103  find / -name libcudnn8
  104  cp /usr/share/lintian/overrides/libcudnn* /usr/local/cuda/lib64
  105  sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
  106  history

				
				

echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "04 von 04: Nouveau - Grafiktreiber ausschalten und reboot"  | tee -a  ~/Installation.log
                sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
                sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
                update-initramfs -u

                reboot

