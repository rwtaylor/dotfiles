#!/bin/bash

# VPSDime
# Follow this: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-centos-7
# Create user centos for consistency w/ amazon AMI

# For all CentOS 7 (Start here with Amazon AMI Cent OS 7)

sudo yum update -y

sudo yum install -y epel-release
sudo yum install -y git R pandoc libcur-devel libxml2-devel openssl-devel \
  curl-devel wget htop httpd-tools automake firewalld

# Setup git
git config --global user.name "Ryan W. Taylor"
git config --global user.email "ryan@ryantaylor.net"
git config --global credential.helper cache
# Remember password for 1 week
git config --global credential.helper 'cache --timeout=604800'
git config --global color.ui true

# Get dotfiles
git clone https://github.com/rwtaylor/dotfiles.git
cp dotfiles/.bash_profile $HOME/
cp dotfiles/.Rprofile $HOME/

# Install r packages
Rscript -e "source('dotfiles/rpackages.R')"


# npm
sudo yum install -y npm
# Upgradd node
sudo npm cache clean -f
sudo npm install -g n
sudo n stable

# Nuclide
sudo npm install -g nuclide-server

# Watchman (for nuclide)
git clone https://github.com/facebook/watchman.git
cd watchman
./autogen.sh
./configure
make
sudo make install

# Install pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip install -U setuptools
sudo pip install -U pip

# Install mkdocs
sudo pip install mkdocs

# Web server
sudo yum install -y nginx




# Setup nginx

# Backup and replace config file
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
sudo cp dotfiles/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy over projects configuration
sudo cp dotfiles/nginx/projects.conf /etc/nginx/conf.d



sudo systemctl start nginx

# Symlinking directories
# Clone main site
# git clone https://github.com/rwtaylor/projects.ryantaylor.net.git
# sudo ln -s /home/centos/projects.ryantaylor.net /usr/share/nginx/html/projects.ryantaylor.net
# For each project site folder

# cd ~/projects
# git clone https://github.com/rwtaylor/2014-male-selection.git
# ln -s  /home/centos/projects/2014-male-selection/site /home/centos/projects.ryantaylor.net/2014-male-selection

# git clone https://github.com/rwtaylor/2015-krsp-gbs-test-run.git
# ln -s  /home/centos/projects/2015-krsp-gbs-test-run/site /home/centos/projects.ryantaylor.net/2015-krsp-gbs-test-run

#
# ln -s  /home/centos/projects/2015-chipmunk/site /home/centos/projects.ryantaylor.net/2015-chipmunk

# Permissions
# Give nginx access to /home/centos and other directories
# chmod a+x /home/centos
# chmod a+x projects.ryantaylor.net
# chmod a+x projects


# Firewalld
sudo systemctl start firewalld
# ssh and http
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http

# For nuclide
sudo firewall-cmd --permanent --add-port=9090-9093/tcp
sudo firewall-cmd --reload
sudo systemctl enable firewalld

# NTP / Timezone
sudo timedatectl set-timezone America/Los_Angeles

sudo yum install ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd
