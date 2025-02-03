#!/bin/bash
#Use archinstall command to install the os and choose bspwm desktop manager
# Update system and install necessary packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel xorg-server xorg-xinit xterm xorg-xrandr xorg-xsetroot dbus

# Make directories
mkdir ~/.config
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
mkdir ~/.config/polybar
mkdir ~/.config/alacritty
mkdir ~/.config/nvim

# Apply config
cp -r config/bspwm $HOME/.config/
cp -r config/sxhkd $HOME/.config/
cp -r config/polybar $HOME/.config/
cp -r config/alacritty $HOME/.config/
cp -r config/nvim $HOME/.config/

mv $HOME/.zshrc $HOME/.zshrc_old
cp config/zsh/.zshrc $HOME/
curl -sS https://starship.rs/install.sh | sh
starship preset gruvbox-rainbow -o ~/.config/starship.toml

# Install yay
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R $(whoami):$(whoami) yay
cd yay
makepkg -si --noconfirm

yay -Syu --noconfirm bspwm lightdm lxappearance sxhkd rofi polybar picom feh wget feh alacritty thunar variety nerd-fonts zsh  xf86-video-intel gedit

# Installing fonts
yay -S papirus-icon-theme ttf-font-awesome --noconfirm
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip Meslo.zip -d /usr/share/fonts
cd /usr/share/themes/
sudo git clone https://github.com/EliverLara/Nordic.git
cd ~
git clone https://github.com/vinceliuice/Layan-cursors.git
cd ~/Layan-cursors/
sudo ./install.sh

#Installing my apps
curl -fsS https://dl.brave.com/install.sh | sh
# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip


