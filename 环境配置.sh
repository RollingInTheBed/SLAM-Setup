sudo -E apt -y update
sudo -E apt install -y build-essential cmake
sudo -E apt install -y qt5-default libvtk6-dev
sudo -E apt install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
sudo -E apt install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev
sudo -E apt install -y libtbb-dev libeigen3-dev
sudo -E apt install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy
sudo -E apt install -y ant default-jdk
sudo -E apt install -y doxygen
sudo -E apt install -y unzip wget curl vim udev htop
sudo -E apt install -y libboost1.58-all-dev redis-server
sudo systemctl enable redis-server
sudo vi /etc/redis/redis.conf
Find And Replace => bind 0.0.0.0
sudo systemctl restart redis
sudo vi /etc/udev/rules.d/01-all-usb-serial.rules
Insert => SUBSYSTEMS=="usb-serial", MODE="0660", GROUP="dialout"
sudo udevadm control --reload-rules
sudo usermod -a -G dialout [USERNAME]

sudo -E add-apt-repository ppa:jonathonf/python-3.6
sudo -E apt -y update
sudo -E apt install -y python3.6 python3.6-dev python3.6-dbg python3.6-venv
sudo -E apt install -y git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev libglfw3-dev
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo -E python3.6 get-pip.py
sudo -E pip3.6 install --target=/usr/local/lib/python3.6/dist-packages numpy
sudo cp -r /usr/lib/python3/dist-packages /usr/local/lib/python3.5
sudo ln -s /usr/share/pyshared /usr/local/share/pyshared
sudo mv /usr/lib/python3 /usr/lib/python3.bak
sudo chown -R root:staff /usr/local/lib/python3.5/dist-packages
wget https://github.com/opencv/opencv/archive/3.4.6.tar.gz -O opencv-3.4.6.tar.gz
wget https://github.com/opencv/opencv_contrib/archive/3.4.6.tar.gz -O opencv_contrib-3.4.6.tar.gz
wget https://github.com/IntelRealSense/librealsense/archive/v2.18.1.tar.gz -O librealsense-2.18.1.tar.gz

# opencv
cmake -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DINSTALL_PYTHON_EXAMPLES=ON \
      -DINSTALL_C_EXAMPLES=OFF \
      -DOPENCV_EXTRA_MODULES_PATH="../../opencv_contrib-3.4.6/modules" \
      -DPYTHON_EXECUTABLE=/usr/bin/python \
      -DPYTHON3_EXECUTABLE=/usr/bin/python3.6 \
      -DOPENCV_ENABLE_NONFREE=ON \
      -DBUILD_EXAMPLES=ON ..
make -j4
sudo make install

# realsense
sudo -E apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo -E apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
sudo -E add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u
sudo -E apt update -y
sudo -E apt install -y librealsense2-dkms

cmake -DBUILD_EXAMPLES=true \
      -DBUILD_WITH_OPENMP=true \
      -DHWM_OVER_XU=false \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_GRAPHICAL_EXAMPLES=true \
      -DBUILD_PYTHON_BINDINGS=true \
      -DPYTHON_EXECUTABLE=/usr/bin/python3.6 \
      ..
make -j4
sudo make install

sudo cp /usr/local/lib/pybackend2.cpython-* /usr/lib/python3.6/
sudo cp /usr/local/lib/pyrealsense2.cpython-* /usr/lib/python3.6/

# git clone
sudo -E pip3.6 install --target=/usr/local/lib/python3.6/dist-packages -r requirements.txt
