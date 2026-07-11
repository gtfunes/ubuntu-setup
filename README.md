# Ubuntu Setup

## Install
```shell
curl -fsSL https://raw.githubusercontent.com/gtfunes/ubuntu-setup/master/setup.sh -o /tmp/setup.sh && bash /tmp/setup.sh
```

Or clone this repo, open a Terminal and run:

```shell
bash setup.sh
```

## What it does
- Asks for your name and email (used for git config and the computer name)
- Generates an SSH key
- Installs dev tools: Git (+ LFS, git-flow), Python 3 (+ pip, venv, pipx), NVM (Node.js LTS), rbenv (Ruby 3.4.8), OpenJDK
- Installs Docker (+ Compose) and adds you to the `docker` group
- Installs KVM/QEMU virtualization tools and virt-manager
- Installs TLP for better battery life on laptops
- Installs apps via Snap: GitKraken, VS Code, Android Studio, Spotify, Slack, Discord, Postman, VLC, Audacity
- Installs Google Chrome, Wine, Lutris and archive extractors
- Installs Claude Code
- Sets up Oh My Zsh with Agnoster theme, plugins and Powerline fonts, and makes zsh the default shell
