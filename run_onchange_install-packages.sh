#!/usr/bin/bash

# Color Definitions
CYAN="36"
GREEN="32"
RED="31"
BOLDGREEN="\e[1;${GREEN}m"
PLAINGREEN="\e[${GREEN}m"
BOLDCYAN="\e[1;${CYAN}m"
PLAINCYAN="\e[${CYAN}m"
PLAINRED="\e[${RED}m"
BOLDRED="\e[1;${RED}m"
ENDCOLOUR="\e[0m"

# Function to display checkbox with color
display_checkbox() {
    if [ "${apps[$1]}" = "y" ]; then
        echo -e "${BOLDGREEN}[x]${ENDCOLOUR} $1"
    else
        echo -e "${BOLDRED}[ ]${ENDCOLOUR} $1"
    fi
}

# Declare an associative array for apps and their installation status
declare -A apps
apps=(
    ["GitHub"]="n"
    ["Junction"]="n"
    ["NVM/NodeJS"]="n"
    ["Docker"]="n"
    ["PHP 8.2"]="n"
    ["Composer"]="n"
    ["Python 3 and 2"]="n"
    ["Ruby"]="n"
    ["Rust"]="n"
    ["Go"]="n"
    ["Java 18"]="n"
)

# Ask questions
for app in "${!apps[@]}"; do
    echo -e "${BOLDCYAN}Would you like to install $app? (y/n)${ENDCOLOUR}"
    read response
    apps[$app]=$response
done

# Confirmation with enhanced summary
echo -e "${BOLDCYAN}You have chosen to install the following:${ENDCOLOUR}"
for app in "${!apps[@]}"; do
    display_checkbox $app
done
echo -e "${BOLDCYAN}Do you want to proceed with the installation? (y/n)${ENDCOLOUR}"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo -e "${BOLDRED}Installation cancelled. Exiting script.${ENDCOLOUR}"
    exit 0
fi

# Installation process starts here
echo -e "${PLAINGREEN}Installing packages...${ENDCOLOUR}"
sudo apt update
sudo apt install nala

# Install basic stuff first

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

echo -e "${PLAINGREEN}Add flathub...${ENDCOLOUR}"

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "${PLAINGREEN}Installing fonts...${ENDCOLOUR}"

sudo nala install fonts-firacode
mkdir -p ~/.local/share/fonts
FONT_DIR="$HOME/.local/share/fonts"
curl -fLo "$FONT_DIR/FiraCodeNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
curl -fLo "$FONT_DIR/FiraCodeNerdFontMono-Medium.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Medium/FiraCodeNerdFontMono-Medium.ttf
curl -fLo "$FONT_DIR/FiraCodeNerdFontMono-Bold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Bold/FiraCodeNerdFontMono-Bold.ttf
curl -fLo "$FONT_DIR/FiraCodeNerdFontMono-Light.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/FiraCodeNerdFontMono-Light.ttf
curl -fLo "$FONT_DIR/FiraCodeNerdFontMono-SemiBold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/SemiBold/FiraCodeNerdFontMono-SemiBold.ttf

echo -e "${PLAINGREEN}Installing Fish...${ENDCOLOUR}"

sudo apt-add-repository ppa:fish-shell/release-3
sudo nala update
sudo nala install fish

echo "${PLAINGREEN}Installing Fisher...${ENDCOLOUR}"

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update

echo -e "${PLAINGREEN}Installing Nala...${ENDCOLOUR}"

curl -sS https://starship.rs/install.sh | sh


# Non-essential package installation:

if [ "${apps["GitHub"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Github CLI...${ENDCOLOUR}"
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo nala update
    sudo nala install gh -y

    echo -e "${PLAINGREEN}Log into Github (using gh auth)? (y/n) [Default: no after 5 seconds]${ENDCOLOUR}"
    read -t 5 response
    if [ $? -eq 0 ]; then
        if [ "$response" = "y" ]; then
            gh auth login
        fi
    else
        echo -e "${PLAINRED}No response. Skipping.${ENDCOLOUR}"
    fi

fi

if [ "${apps["Junction"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Junction...${ENDCOLOUR}"
    flatpak install flathub re.sonny.Junction
    xdg-settings set default-web-browser re.sonny.Junction.desktop
fi

if [ "${apps["NVM/NodeJS"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing NVM/NodeJS...${ENDCOLOUR}"
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source ~/.bashrc
    nvm install node
    nvm use node
fi

if [ "${apps["Docker"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Docker...${ENDCOLOUR}"
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

if [ "${apps["PHP 8.2"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing PHP 8.2...${ENDCOLOUR}"
    sudo add-apt-repository ppa:ondrej/php
    sudo nala update
    sudo nala install php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-mbstring php8.2-mysql php8.2-xml php8.2-zip php8.2-bcmath php8.2-intl php8.2-imagick php8.2-redis php8.2-xdebug
fi

if [ "${apps["Composer"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Composer...${ENDCOLOUR}"
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar ~/.local/bin/composer
fi

if [ "${apps["Python 3 and 2"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Python 3...${ENDCOLOUR}"
    sudo nala install -y python3 python3-pip python3-venv python3-dev

    echo -e "${PLAINGREEN}Installing Python 2...${ENDCOLOUR}"
    sudo nala install -y python2 python-pip python-virtualenv python-dev
fi

if [ "${apps["Ruby"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Ruby...${ENDCOLOUR}"
    sudo nala install -y ruby-full
fi

if [ "${apps["Rust"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Rust...${ENDCOLOUR}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

fi

if [ "${apps["Java"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Go...${ENDCOLOUR}"
    sudo nala install -y golang-go
fi

if [ "${apps["Java 18"]}" = "y" ]; then
    echo -e "${PLAINGREEN}Installing Java 18...${ENDCOLOUR}"
    sudo nala install -y openjdk-18-jdk
fi

echo -e "${BOLDGREEN}Package installation done!${ENDCOLOUR}"