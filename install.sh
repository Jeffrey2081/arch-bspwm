#!/bin/bash
# Update system and install necessary packages
sudo sed -i 's/^#ParallelDownloads = [0-9]\+/ParallelDownloads = 5/' /etc/pacman.conf
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel xorg xorg-server xorg-xinit unzip xorg-xrandr xorg-xsetroot dbus

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
cp -r rofi $HOME/.config/
sudo cp -r fonts/* /usr/share/fonts/
cp -r alacritty/ $HOME/.config/
mv $HOME/.zshrc $HOME/.zshrc_old
cp -r .zshrc $HOME/
chmod -R +x ~/.config/*
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/onedark-theme/launch.sh
chmod +x ~/.config/polybar/onedark-theme/polybar/scripts/powermenu.sh
chmod +x ~/.config/polybar/onedark-theme/polybar/scripts/update-system.sh
chmod +x ~/.zshrc
# Install yay
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R $(whoami):$(whoami) yay
cd yay
makepkg -si --noconfirm

#Installing apps
yay -Syu --noconfirm bspwm samba cifs-utils starship lightdm-gtk-greeter variety pacman-contrib wmctrl code lightdm gtk3 gtk3-nocsd qt5-base qt5ct kvantum-qt5 lxappearance neovim xclip fastfetch sxhkd mpd rofi polybar picom pavucontrol feh wget alacritty thunar nerd-fonts zsh gedit
yay -R --noconfirm xterm rxvt-unicode
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
systemctl --user enable dbus 
#Installing my apps and setting up qemu
curl -fsS https://dl.brave.com/install.sh | sh
yay -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs
sudo systemctl enable --now libvirtd
sudo sed -i 's/^#\(unix_sock_group = "libvirt"\)/\1/; s/^#\(unix_sock_rw_perms = "0770"\)/\1/' /etc/libvirt/libvirtd.conf
sudo systemctl restart libvirtd
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
sudo virsh net-autostart default
#Disabling grub bootloader timeout

GRUB_CONFIG="/etc/default/grub"

# Backup the existing GRUB config
sudo cp "$GRUB_CONFIG" "$GRUB_CONFIG.bak"

# Modify GRUB_TIMEOUT value
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' "$GRUB_CONFIG"

echo "✅ GRUB timeout disabled. Updating GRUB..."

# Update GRUB
if [ -f /boot/grub/grub.cfg ]; then
   sudo  grub-mkconfig -o /boot/grub/grub.cfg
elif [ -f /boot/grub2/grub.cfg ]; then
    sudo grub-mkconfig -o /boot/grub2/grub.cfg
else
    echo "❌ GRUB config not found! Manual update may be required."
    exit 1
fi

echo "✅ GRUB update complete. ."
# Reloading Font
chsh -s $(which zsh)
fc-cache -vf
echo "⚠️ WARNING: Reboot to apply changes"  



