#!/bin/bash -eu

# Copyright 2014 gandalf authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Install dependencies
echo "Updating Ubuntu... (patience, this will take long)"
apt-get update
apt-get dist-upgrade -y
echo "Installing dependencies... (patience, this will take long)"
apt-get install $(grep -vE "^\s*#" /vagrant/requirements.apt | tr "\n" " ") -y

# Check OpenCV installation
echo "Checking whether OpenCV installed right or not..."
python -c 'import cv, cv2, cv2.cv' || { echo 'OpenCV did not install correctly' ; exit 1 ; }

# If it's all good, proceed and install Thumbor and OpenCVEngine
echo "Installing thumbor and opencv-engine..."
pip install thumbor opencv-engine

# Start Thumbor on port 8888
echo "Starting thumbor on port 8888..."
thumbor -c /vagrant/thumbor.conf -p 8888 &

echo "Done!"
