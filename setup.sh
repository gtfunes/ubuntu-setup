#!/bin/bash
# Ubuntu post-install setup script

# User
name=""
email=""

while [ -z "$name" ]; do
  read -r -p "What's your name? " name < /dev/tty || { echo "No terminal available for input"; exit 1; }
done

while [ -z "$email" ] || [[ "$email" != *"@"* ]]; do
  read -r -p "What's your email? " email < /dev/tty || { echo "No terminal available for input"; exit 1; }
done

echo ""
echo "Hey $name, lets setup your new Ubuntu!"
echo "You'll be asked for your password a few times during this process"
echo "*************************************"

# Create a private key
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
  echo "---> Creating your private key..."
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -C "$email"
fi

# Set computer name
echo "---> Setting computer name..."
sudo hostnamectl set-hostname "${name// /-}"

# Enable extra repositories (universe/multiverse, plus up-to-date TLP and Lutris)
echo "---> Enabling extra repositories..."
sudo apt-get update
sudo apt-get install -y software-properties-common ca-certificates
sudo add-apt-repository -y -n universe
sudo add-apt-repository -y -n multiverse
sudo add-apt-repository -y -n ppa:linrunner/tlp
sudo add-apt-repository -y -n ppa:lutris-team/lutris

# Before we start, update!
echo "---> Updating packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install some essentials
echo "---> Installing essential packages..."
sudo apt-get install -y build-essential libssl-dev apt-transport-https gnupg wget curl vim

# Git
echo "---> Installing Git..."
sudo apt-get install -y git git-lfs git-flow
git lfs install
git config --global user.name "$name"
git config --global user.email "$email"

# Python
echo "---> Installing Python..."
sudo apt-get install -y python3 python3-dev python3-pip python3-venv pipx libkrb5-dev

# Node.js via NVM
echo "---> Installing NVM and Node.js LTS..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
fi
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'

# Ruby via rbenv
echo "---> Installing rbenv and Ruby..."
sudo apt-get install -y autoconf libyaml-dev zlib1g-dev libffi-dev libgmp-dev rustc
if [ ! -d "$HOME/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
  git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
rbenv install -s 3.4.8
rbenv global 3.4.8

# Installing JDK
echo "---> Installing JDK..."
sudo apt-get install -y default-jdk

# Archive extractors
echo "---> Installing archive extractors..."
sudo apt-get install -y zip unzip p7zip-full p7zip-rar unrar sharutils cabextract file-roller

# TLP - saves battery when Ubuntu is installed on laptops
echo "---> Installing TLP..."
sudo apt-get remove -y laptop-mode-tools
sudo apt-get install -y tlp tlp-rdw smartmontools ethtool
sudo tlp start
sudo tlp-stat -s

# KVM acceleration and cpu checker
echo "---> Installing virtualization tools..."
sudo apt-get install -y cpu-checker qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo adduser "$USER" libvirt

# Google Chrome
if ! command -v google-chrome > /dev/null; then
  echo "---> Installing Google Chrome..."
  wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt-get install -y /tmp/google-chrome-stable_current_amd64.deb
  rm /tmp/google-chrome-stable_current_amd64.deb
fi

# Docker
echo "---> Installing Docker..."
sudo apt-get install -y docker.io docker-compose-v2
sudo usermod -aG docker "$USER"

# Snap apps
echo "---> Installing Snap apps..."
sudo apt-get install -y snapd
sudo snap install gitkraken --classic
sudo snap install code --classic
sudo snap install android-studio --classic
sudo snap install spotify
sudo snap install slack
sudo snap install discord
sudo snap install postman
sudo snap install vlc
sudo snap install audacity

# Get some wine (and Lutris)
echo "---> Installing Wine & Lutris..."
sudo apt-get install -y wine64 lutris

# Install AI tools
echo "---> Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

# Zsh & Oh-My-Zsh
echo "---> Installing Zsh & Oh-My-Zsh..."
sudo apt-get install -y zsh fonts-powerline
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install custom plugins (skip if already cloned)
zsh_custom="$HOME/.oh-my-zsh/custom"
if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
fi
if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom/plugins/zsh-syntax-highlighting"
fi

# Set Agnoster theme and plugins
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$HOME/.zshrc"
sed -i 's/^plugins=(git)$/plugins=(git node npm docker zsh-autosuggestions zsh-syntax-highlighting colored-man-pages copyfile extract)/' "$HOME/.zshrc"

# Make NVM and rbenv available in zsh (their installers only touch ~/.bashrc)
if ! grep -q "NVM_DIR" "$HOME/.zshrc"; then
  cat >> "$HOME/.zshrc" << 'EOF'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
EOF
fi

if ! grep -q "rbenv init" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" << 'EOF'

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
EOF
fi

# Change the default shell to zsh
echo "---> Switching default shell to zsh..."
sudo chsh -s "$(command -v zsh)" "$USER"

echo "*************************************"
echo "All done! Enjoy your new Ubuntu!"
notify-send "Ubuntu Setup" "All done!" 2> /dev/null || true
