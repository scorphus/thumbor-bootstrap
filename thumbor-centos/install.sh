#!/bin/bash -eu

# Copyright 2015 Pablo Santiago Blum de Aguiar <scorphus@gmail.com>
# Use of this source code is governed by the MIT license which can
# be found in the LICENSE file.

# Install dependencies
echo "Updating CentOS... (patience, this will take long)"
yum -y update

# Install Python 2.7.9
echo "Installing Python 2.7.9... (patience, this will take long)"
. /vagrant/python279_install.sh

echo "Done!"
