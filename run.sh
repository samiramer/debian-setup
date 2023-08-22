#!/bin/sh

dpkg-reconfigure console-setup

apt-get -y install lsb-release ca-certificates curl
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update

apt update
apt upgrade
apt install -y wget curl sudo vim git build-essential pipewire-audio bluetooth zsh \
	firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers \
	xserver-xorg-core xserver-xorg-video-amdgpu x11-utils x11-xserver-utils xinit xkb-data x11-xkb-utils \
	alacritty libx11-dev libxft-dev libxinerama-dev libxrandr-dev blueman network-manager-gnome \
	redshift-gtk gnome-keyring libpam-gnome-keyring seahorse pamixer pasystray pavucontrol libsecret-tools \
	policykit-1 policykit-1-gnome xdg-user-dirs software-properties-common \
	ninja-build gettext cmake unzip tmux stow lxappearance arc-theme fzf feh xautolock xss-lock i3lock libnotify-bin \
  flameshot

cp 20-amdgpu.conf /etc/X11/xorg.conf.d/20-amdgpu.conf

usermod -aG sudo --shell /usr/bin/zsh samer

systemctl enable bluetooth
systemctl --user enable gnome-keyring-daemon

echo "options btusb enable_autosuspend=0" > /etc/modprobe.d/btusb_autosuspend-disable.conf

if ! [ -x "$(command -v google-chrome)" ]; then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
	apt install -y /tmp/chrome.deb
fi

if ! [ -d /home/samer/dmenu ]; then
	git clone https://git.suckless.org/dmenu /home/samer/dmenu
fi

if ! [ -x "$(command -v dmenu)" ]; then
  cd /home/samer/dmenu
  make clean install
fi

if ! [ -d /home/samer/dwm ]; then
	git clone https://git.suckless.org/dwm /home/samer/dwm
fi

if ! [ -x "$(command -v dwm)" ]; then
  cd /home/samer/dwm
  sed -i 's/"st"/"alacritty"/g' config.def.h
  make clean install
fi

if ! [ -x "$(command -v nvm)" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
fi

if [ "$(fc-list|grep Cascaydia|wc -l)" -eq 0]; then
  git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts.git /tmp/nerd-fonts
  cd /tmp/nerd-fonts
  git sparse-checkout add patched-fonts/CascadiaCode
  ./install.sh
  cd /
fi

if ! [ -x "$(command -v lazygit)" ]; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  cd /tmp
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
fi

wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
