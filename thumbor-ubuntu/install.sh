#!/bin/bash -eu

# Copyright 2015 Pablo Santiago Blum de Aguiar <scorphus@gmail.com>
# Use of this source code is governed by the MIT license which can
# be found in the LICENSE file.

# Install dependencies
echo "Installing dependencies... (patience, this will take long)"
apt-get update
apt-get install $(grep -vE "^\s*#" /vagrant/requirements.apt | tr "\n" " ") -y

# Check OpenCV installation
echo "Checking whether OpenCV installed right or not..."
python -c 'import cv, cv2, cv2.cv' || { echo 'OpenCV did not install correctly' ; exit 1 ; }

# If it's all good, proceed and install Thumbor and OpenCVEngine
echo "Installing Thumbor with GraphicsMagickEngine and OpenCVEngine..."
cd /vagrant
virtualenv .e
set +u
source .e/bin/activate
set -u
git clone https://github.com/thumbor/thumbor.git
pip install -e ./thumbor/
git clone https://github.com/thumbor/graphicsmagick-engine.git
pip install -e ./graphicsmagick-engine/
git clone https://github.com/thumbor/opencv-engine.git
pip install -e ./opencv-engine/

# Start Thumbor instances
echo "Starting Thumbor with GraphicsMagick on port 8881..."
thumbor -c /vagrant/thumbor-graphicsmagick.conf -p 8881 -l debug > /vagrant/thumbor-graphicsmagick.log &
echo "Starting Thumbor with OpenCV on port 8882..."
thumbor -c /vagrant/thumbor-opencv.conf -p 8882 -l debug > /vagrant/thumbor-opencv.log &
echo "Starting Thumbor with PIL on port 8883..."
thumbor -c /vagrant/thumbor-pil.conf -p 8883 -l debug > /vagrant/thumbor-pil.log &

echo "Done!"
