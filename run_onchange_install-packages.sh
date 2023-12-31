#!/usr/bin/bash

echo "Start package instatllation script"

echo "Installing packages..."

sudo apt update

sudo apt install nala

sudo nala install -y \
    build-essential \
    git \
    nano \
    curl \
    wget \
    vim \
    gnupg \
    gnupg2 \
    openssl \
    software-properties-common \
    zip \
    unzip \
    ca-certificates \
    flatpak \
    gnome-software-plugin-flatpak \
    aptitude \

echo "Add flathub..."

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installing fonts..."

sudo nala install fonts-firacode
git clone https://github.com/ryanoasis/nerd-fonts.git
./install.sh FiraCode

echo "Installing Fish..."

sudo apt-add-repository ppa:fish-shell/release-3
sudo nala update
sudo nala install fish

echo "Installing Fisher..."

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update

echo "Installing Nala..."

curl -sS https://starship.rs/install.sh | sh

echo "World you like to install Junction? (y/n)"

read junction

if [ $junction = "y" ]; then
    flatpak install flathub re.sonny.Junction
    xdg-settings set default-web-browser re.sonny.Junction.desktop
fi

echo "Would you like to install NVM/NodeJS? (y/n)"

read nodejs

if [ $nodejs = "y" ]; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source ~/.bashrc
    nvm install node
    nvm use node
fi

echo "Would you like to install Docker? (y/n)"

read docker

if [ $docker = "y" ]; then
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo nala remove $pkg; done
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo nala update

    sudo nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo "Would you like to install PHP 8.2? (y/n)"

read php

if [ $php = "y" ]; then
    sudo add-apt-repository ppa:ondrej/php
    sudo nala update
    sudo nala install php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-mbstring php8.2-mysql php8.2-xml php8.2-zip php8.2-bcmath php8.2-intl php8.2-imagick php8.2-redis php8.2-xdebug
fi

echo "Would you like to install Composer? (y/n)"

read composer

if [ $composer = "y" ]; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar ~/.local/bin/composer
fi

echo "Would you like to install Python 3? (y/n)"

read python

if [ $python = "y" ]; then
    sudo nala install python3 python3-pip python3-venv python3-dev
fi

echo "Would you like to install Ruby? (y/n)"

read ruby

if [ $ruby = "y" ]; then
    sudo nala install ruby-full
fi

echo "Would you like to install Rust? (y/n)"

read rust

if [ $rust = "y" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

fi

echo "Would you like to install Go? (y/n)"

read go

if [ $go = "y" ]; then
    sudo nala install golang-go
fi

echo "Would you like to install Java 18? (y/n)"

read java

if [ $java = "y" ]; then
    sudo nala install openjdk-18-jdk
fi

echo "Package installation done."