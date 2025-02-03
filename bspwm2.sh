#!/bin/bash
# Update system and install necessary packages
sudo sed -i 's/^#ParallelDownloads = [0-9]\+/ParallelDownloads = 5/' /etc/pacman.conf
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel xorg xorg-server xorg-xinit unzip xterm xorg-xrandr xorg-xsetroot dbus

# Make directories
mkdir ~/.config
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
mkdir ~/.config/polybar
#wallpaper
cp -r wallpaper.jpg $HOME/wallpaper.jpg
# Apply config
cp -r bspwm/ $HOME/.config/
cp -r sxhkd/ $HOME/.config/
cp -r polybar/ $HOME/.config/
cp -r alacritty/ $HOME/.config/
mv $HOME/.zshrc $HOME/.zshrc_old
cp config/zsh/.zshrc $HOME/
curl -sS https://starship.rs/install.sh | sh
starship preset gruvbox-rainbow -o ~/.config/starship.toml
chmod -R +x ~/.config/*
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh
# Install yay
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R $(whoami):$(whoami) yay
cd yay
makepkg -si --noconfirm

#Installing apps
yay -Syu --noconfirm bspwm lightdm lxappearance sxhkd rofi polybar picom pavucontrol code feh wget feh alacritty thunar nitrogen nerd-fonts zsh gedit

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
systemctl --user enable dbus --now
#Installing my apps
curl -fsS https://dl.brave.com/install.sh | sh
# Reloading Font
fc-cache -vf




