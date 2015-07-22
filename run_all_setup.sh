#!/bin/bash
sudo yum update -y

sudo yum install -y git R texlive pandoc libcur-devel libxml2-devel openssl-devel

# Setup git
git config --global user.name "Ryan W. Taylor"
git config --global user.email "ryan@ryantaylor.net"
git config --global credential.helper cache
# Remember password for 1 week
git config --global credential.helper 'cache --timeout=604800'

# Get dotfiles
git clone https://github.com/rwtaylor/dotfiles.git
cp dofiles/.bash_profile $HOME?
cp dotfiles/.Rprofile $HOME/

# Install r packages
Rscript -e "source('dotfiles/rpackages.R')"
