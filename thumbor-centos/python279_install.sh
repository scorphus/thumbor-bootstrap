#!/bin/bash -eu

#######################################################
#                                                     #
# Python 2.7.9 Install on CentOS 6.4
# Adapted from https://gist.github.com/timss/5122008
# Adapted from https://www.digitalocean.com/community/tutorials/how-to-set-up-python-2-7-6-and-3-3-3-on-centos-6-4
#
# Installs to /usr/local/{bin,lib}
# Seperate from system default
# /usr/bin/python(2.6)
#                                                     #
#######################################################

# Require root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi


# Install required packages for compilation
yum -y groupinstall "Development tools"
yum -y install {zlib,bzip2,openssl,ncurses,sqlite}-devel wget xz


# Install Python 2.7
# Download Python 2.7.9 source code
cd /tmp
mkdir python279
cd python279
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
tar xf Python-2.7.9.tar.xz
cd Python-2.7.9

# Configure with shared libraries, used by mod_wsgi
./configure --prefix=/usr/local --enable-shared

# Compile and install
make
make altinstall # *NOT* install, very important!


# Fix paths
# Fix path to shared lib - http://stackoverflow.com/a/7880519/1076493
echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

# Adjust $PATH to include /usr/local/lib
cp /vagrant/path.sh /etc/profile.d/
export PATH="$PATH:/usr/local/bin"


# Install setuptools and pip
# Let's download the installation file using wget:
cd /tmp/python279
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-15.1.tar.gz

# Extract the files from the archive:
tar xf setuptools-15.1.tar.gz

# Enter the extracted directory:
cd setuptools-15.1

# Install setuptools using the Python we've installed (2.7.6)
python2.7 setup.py install

# Install pip
curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -


# Install virtualenv and other interesting packages
pip install virtualenv yolk bpython


# Clean up
rm -rf /tmp/python279


# Done!
echo "Installation of Python 2.7.9 Done!"
