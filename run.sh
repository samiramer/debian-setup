#!/bin/sh

dpkg-reconfigure console-setup

cp debian-testing.list /etc/apt/sources.list.d/debian-testing.list
cp debian.pref /etc/apt/preferences.d/debian.pref

apt update
apt upgrade
apt install -y wget curl sudo vim git build-essential pipewire-audio bluetooth zsh \
	firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers \
	xserver-xorg-core xserver-xorg-video-amdgpu x11-utils x11-xserver-utils xinit xkb-data x11-xkb-utils \
	alacritty libx11-dev libxft-dev libxinerama-dev blueman network-manager-gnome \
	redshift-gtk gnome-keyring libpam-gnome-keyring seahorse pamixer pasystray pavucontrol libsecret-tools \
	policykit-1 policykit-1-gnome xdg-user-dirs

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

cd /home/samer/dmenu
make clean install

if ! [ -d /home/samer/dwm ]; then
	git clone https://git.suckless.org/dwm /home/samer/dwm
fi

cd /home/samer/dwm
sed -i 's/"st"/"alacritty"/g' config.def.h
make clean install
