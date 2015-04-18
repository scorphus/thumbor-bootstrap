#!/bin/bash -eu

# Copyright 2014 gandalf authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Install dependencies
echo "Installing dependencies... (patience, this will take long)"
apt-get update
apt-get install $(grep -vE "^\s*#" /vagrant/requirements.apt | tr "\n" " ") -y

# Clone OpenCV repository and checkout tag 2.4.10
echo "Downloading and extracting OpenCV 2.4.10... (patience, this will take long)"
cd /vagrant/
wget -O opencv-2.4.10.zip http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.10/opencv-2.4.10.zip/download
unzip -o opencv-2.4.10.zip
cd opencv-2.4.10

# Build and install OpenCV
echo "Preparing to build OpenCV 2.4.10..."
mkdir release
cd release/
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
echo "Building OpenCV 2.4.10..."
make
echo "Installing OpenCV 2.4.10... (patience, this will take really long)"
make install

# Check OpenCV installation
echo "Checking whether OpenCV installed wight or not..."
python -c 'import cv, cv2, cv2.cv' || { echo 'OpenCV did not install correctly' ; exit 1 ; }

# If it's all good, proceed and install Thumbor and OpenCVEngine
echo "Installing thumbor and opencv-engine..."
pip install thumbor opencv-engine

# Start Thumbor on port 8888
echo "Starting thumbor on port 8888..."
thumbor -c /vagrant/thumbor.conf -p 8889 &

echo "Done!"
