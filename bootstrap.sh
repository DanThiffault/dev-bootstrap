#!/bin/sh

# Use multiverse
sudo sh -c "echo \"\" >> /etc/apt/sources.list"
sudo sh -c "echo \"# Enable multiverse packages\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb http://ap-southeast-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb-src http://ap-southeast-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb http://ap-southeast-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb-src http://ap-southeast-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse\" >> /etc/apt/sources.list"
sudo sh -c "echo \"\" >> /etc/apt/sources.list"

# Grab any system updates
sudo apt-get -y update
sudo apt-get -y upgrade

# Tools needed to build ruby
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev git-core

# Grab and build ruby 
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p327.tar.gz
tar -xvzf ruby-1.9.3-p327.tar.gz
cd ruby-1.9.3-p327/
./configure --prefix=/usr/local
make
sudo make install

# Install the gems needed for chef
sudo gem install chef ruby-shadow --no-ri --no-rdoc


# Setup S3 vars
echo "S3_KEY: "
read S3_KEY
export S3_KEY=$S3_KEY

echo "S3_SECRET: "
read S3_SECRET
export S3_SECRET=$S3_SECRET

# Run Chef 
cd ~/dev-bootstrap
sudo chef-solo -c solo.rb -j solo.json

# Switch shell
sudo chsh -s /usr/bin/zsh ubuntu


