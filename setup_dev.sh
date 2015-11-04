#!/bin/bash

# Based on this: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-centos-7

# Setup new user
# Create user
adduser ryan
passwd ryan

# root privileges
gpasswd -a ryan wheel

# add key to authorized keys
# ssh-copy-id user@123.45.56.78
# ssh ryan@123.45.56.78

# Disable password login
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd


# Setup Server

# For all CentOS 7 (Start here with Amazon AMI Cent OS 7)

sudo yum update -y

sudo yum install -y epel-release
sudo yum install -y git htop

# R pandoc libcur-devel libxml2-devel openssl-devel \
# curl-devel wget htop httpd-tools automake firewalld mosh

# Setup git
git config --global user.name "Ryan W. Taylor"
git config --global user.email "ryan@ryantaylor.net"
git config --global credential.helper cache
# Remember password for 1 week
git config --global credential.helper 'cache --timeout=604800'
git config --global color.ui true

# Get dotfiles
git clone https://github.com/rwtaylor/dotfiles.git
ln -s dotfiles/.bash_profile $HOME/.bash_profile
#cp dotfiles/.Rprofile $HOME/

# Install r packages
# Open R and install a packages to create personal library...
# Rscript -e "source('dotfiles/rpackages.R')"

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

# Copy over htpasswd
sudo mkdir -p /etc/nginx/httpassword
# From MBP or wherever
#
scp ~/Sites/httpasswd/projects.ryantaylor.net ryan@45.55.4.32:~/prwt_httpasswd

# Back to server
sudo mv ~/prwt_httpasswd /etc/nginx/httpasswd/projects.ryantaylor.net

sudo systemctl start nginx

# Symlinking directories
# Clone main site
git clone https://github.com/rwtaylor/projects.ryantaylor.net.git
sudo ln -s ~/projects.ryantaylor.net /usr/share/nginx/html/projects.ryantaylor.net
# For each project site folder

mkdir -p ~/projects
cd ~/projects
git clone https://github.com/rwtaylor/2014-male-selection.git
ln -s  ~/projects/2014-male-selection/site ~/projects.ryantaylor.net/2014-male-selection

git clone https://github.com/rwtaylor/2015-krsp-gbs-test-run.git
ln -s  ~/projects/2015-krsp-gbs-test-run/site ~/projects.ryantaylor.net/2015-krsp-gbs-test-run

#
# ln -s  ~/projects/2015-chipmunk/site ~/projects.ryantaylor.net/2015-chipmunk

# Permissions
# Give nginx access to /home/ryan and other directories
chmod a+x /home/ryan
chmod a+x projects.ryantaylor.net
chmod a+x projects


# Firewalld
sudo systemctl start firewalld
# ssh and http
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http

# For mosh
sudo firewall-cmd --permanent --remove-port=9090-9093/tcp

sudo firewall-cmd --permanent --add-port=60000-61000/udp
sudo firewall-cmd --reload
sudo systemctl enable firewalld

# NTP / Timezone
sudo timedatectl set-timezone America/Los_Angeles

sudo yum install -y ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd
