#!/bin/bash
# Update system and install necessary packages
sed -i 's/^#ParallelDownloads = [0-9]\+/ParallelDownloads = 5/' /etc/pacman.conf
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel xorg xorg-server xorg-xinit unzip xorg-xrandr xorg-xsetroot dbus

# Make directories
mkdir /home/$USERNAME/.config
mkdir /home/$USERNAME/.config/bspwm
mkdir /home/$USERNAME/.config/sxhkd
mkdir /home/$USERNAME/.config/polybar
#wallpaper
cp -r wallpaper.jpg /home/$USERNAME/wallpaper.jpg
# Apply config
cp -r bspwm/ /home/$USERNAME/.config/
cp -r sxhkd/ /home/$USERNAME/.config/
cp -r polybar/ /home/$USERNAME/.config/
cp -r rofi /home/$USERNAME/.config/
cp -r fonts/* /usr/share/fonts/
cp -r alacritty/ /home/$USERNAME/.config/
mv /home/$USERNAME/.zshrc /home/$USERNAME/.zshrc_old
cp -r .zshrc /home/$USERNAME/
chmod -R +x /home/$USERNAME//.config/*
chmod +x /home/$USERNAME/.config/bspwm/bspwmrc
chmod +x /home/$USERNAME/.config/sxhkd/sxhkdrc
chmod +x /home/$USERNAME/.config/bspwm/bspwmrc
chmod +x /home/$USERNAME/.config/polybar/onedark-theme/launch.sh
chmod +x /home/$USERNAME/.config/polybar/onedark-theme/polybar/scripts/powermenu.sh
chmod +x /home/$USERNAME/.config/polybar/onedark-theme/polybar/scripts/update-system.sh
chmod +x /home/$USERNAME/.zshrc
# Install yay
cd /opt
git clone https://aur.archlinux.org/yay.git
chown -R $USERNAME:$USERNAME yay
cd yay
su - $USERNAME -c "makepkg -si --noconfirm"

#Installing apps
su - $USERNAME -c "yay -Syu --noconfirm bspwm floorp-bin samba cifs-utils starship lightdm-gtk-greeter variety pacman-contrib wmctrl code lightdm gtk3 gtk3-nocsd qt5-base qt5ct kvantum-qt5 lxappearance neovim xclip fastfetch sxhkd mpd rofi polybar picom pavucontrol feh wget alacritty thunar nerd-fonts zsh gedit"
su - $USERNAME -c "yay -R --noconfirm xterm rxvt-unicode"
# Installing fonts
su - $USERNAME -c "yay -S papirus-icon-theme ttf-font-awesome --noconfirm"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /usr/share/fonts
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd /home/$USERNAME/
git clone https://github.com/vinceliuice/Layan-cursors.git
cd /home/$USERNAME//Layan-cursors/
 ./install.sh
systemctl --user enable dbus 
#Installing my apps and setting up qemu
su - $USERNAME -c "yay -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs"
systemctl enable libvirtd
sed -i 's/^#\(unix_sock_group = "libvirt"\)/\1/; s/^#\(unix_sock_rw_perms = "0770"\)/\1/' /etc/libvirt/libvirtd.conf
systemctl restart libvirtd
usermod -a -G libvirt $USERNAME
newgrp libvirt
virsh net-autostart default
#Disabling grub bootloader timeout

GRUB_CONFIG="/etc/default/grub"

# Backup the existing GRUB config
cp "$GRUB_CONFIG" "$GRUB_CONFIG.bak"

# Modify GRUB_TIMEOUT value
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' "$GRUB_CONFIG"

echo "✅ GRUB timeout disabled. Updating GRUB..."

# Update GRUB
if [ -f /boot/grub/grub.cfg ]; then
    grub-mkconfig -o /boot/grub/grub.cfg
elif [ -f /boot/grub2/grub.cfg ]; then
   grub-mkconfig -o /boot/grub2/grub.cfg
else
    echo "❌ GRUB config not found! Manual update may be required."
    exit 1
fi

echo "✅ GRUB update complete. ."
# Reloading Font
fc-cache -vf
exit


