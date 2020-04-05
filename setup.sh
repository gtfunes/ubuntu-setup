#!/bin/bash

echo "\n\nWelcome to you new system!\n"
echo "Installing everything...\n"

# Before we start, update!
sudo apt-get update

# Install some essentials
sudo apt-get install -y build-essential libssl-dev software-properties-common apt-transport-https wget vim curl gdebi-core 

# Nodejs and NVM
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

# Git
sudo apt-get install -y git

# Python
sudo apt-get install -y python-software-properties
sudo apt-get install -y python-dev, python-pip
sudo apt-get install -y libkrb5-dev

# Ruby
sudo apt-get install -y rubygems-integration
sudo gem install rbenv ruby-build ruby-dev

# Get some wine
sudo apt-get install -y wine64

# Installing JDK and JRE
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk

# Archive Extractors
sudo apt-get install -y unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

# TLP - saves battery when Ubuntu is installed on Laptops
sudo apt-get remove laptop-mode-tools
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install -y tlp tlp-rdw smartmontools ethtool
sudo tlp start
sudo tlp stat

# KVM acceleration and cpu checker
sudo apt-get install -y cpu-checker
sudo apt-get install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
sudo apt-get install -y virt-manager
sudo apt-get install -y lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo rm google-chrome-stable_current_amd64.deb

# Snap!
sudo apt-get install snapd

# GitKraken
sudo snap install gitkraken

# Visual Studio Code
sudo snap install code --classic

# Spotify
sudo snap install spotify

# Slack
sudo snap install slack --classic

# Discord
sudo snap install discord

# Postman
sudo snap install postman

# VLC
sudo snap install vlc

# Audacity
sudo snap install audacity

# Android Studio
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
sudo snap install android-studio --classic

# Lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt-get update
sudo apt-get install -y lutris

# Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# SSH key pair
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "\n\nGenerating key pair for SSH\n"
  ssh-keygen
fi

echo "\nAll done! Enjoy your new Ubuntu!"
