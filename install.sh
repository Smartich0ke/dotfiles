#!/bin/bash
rm -f ~/.profile
rm -f ~/.gitconfig
rm -f ~/.bash_profile
rm -f ~/.bashrc
ln -sf $PWD/.bashrc $HOME/.bashrc
ln -sf $PWD/.bash_profile $HOME/.bash_profile
ln -sf $PWD/.profile $HOME/.profile
ln -sf $PWD/.gitconfig $HOME/.gitconfig

echo 'Symlinks created'

sudo apt-get -y update
sudo apt-get -y upgrade

echo 'Installing all packages expressly installed by apt (packages/packages-apt-development.txt)... This may take a while...'
sudo apt-get -y --ignore-missing install $(cat packages/packages-apt-development.txt)

echo 'installing all packages expressly installed by pip (packages/packages-pip.txt)... This may take a while...'
sudo pip install $(cat packages/packages-apt-development.txt)

echo 'installing nvm...'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
