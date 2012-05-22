#!/bin/sh

# Grab any system updates
sudo apt-get -y update
sudo apt-get -y upgrade

# Tools needed to build ruby
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev git-core

# Grab and build ruby 
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar -xvzf ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194/
./configure --prefix=/usr/local
make
sudo make install

# Install the gems needed for chef
sudo gem install chef ruby-shadow --no-ri --no-rdoc

# Run Chef 
cd ~/dev-bootstrap
sudo chef-solo -c solo.rb -j solo.json
