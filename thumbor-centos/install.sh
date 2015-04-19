#!/bin/bash -eu

# Copyright 2014 gandalf authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Install dependencies
echo "Updating CentOS... (patience, this will take long)"
yum -y update

# Install Python 2.7.9
echo "Installing Python 2.7.9... (patience, this will take long)"
. /vagrant/python279_install.sh

echo "Done!"
