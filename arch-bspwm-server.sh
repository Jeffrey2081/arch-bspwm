#!/bin/bash
set -eo pipefail

# Arch Linux BSPWM Server / Chroot Setup Script
TARGET_USER="${USERNAME:-$(logname 2>/dev/null || whoami)}"
USER_HOME=$(eval echo "~$TARGET_USER")

echo "Running post-install setup for user: $TARGET_USER ($USER_HOME)"

# Update pacman conf
sed -i 's/^#ParallelDownloads = [0-9]\+/ParallelDownloads = 5/' /etc/pacman.conf
pacman -Syu --noconfirm
pacman -S --needed --noconfirm base-devel xorg xorg-server xorg-xinit unzip xorg-xrandr xorg-xsetroot dbus git

# Create directories safely
mkdir -p "$USER_HOME"/.config/{bspwm,sxhkd,polybar,rofi,alacritty}

# Copy configs
[ -f wallpaper.jpg ] && cp wallpaper.jpg "$USER_HOME/wallpaper.jpg"
[ -d bspwm ] && cp -r bspwm/* "$USER_HOME/.config/bspwm/"
[ -d sxhkd ] && cp -r sxhkd/* "$USER_HOME/.config/sxhkd/"
[ -d polybar ] && cp -r polybar/* "$USER_HOME/.config/polybar/"
[ -d rofi ] && cp -r rofi/* "$USER_HOME/.config/rofi/"
[ -d alacritty ] && cp -r alacritty/* "$USER_HOME/.config/alacritty/"
[ -d fonts ] && cp -r fonts/* /usr/share/fonts/

if [ -f "$USER_HOME/.zshrc" ]; then
    cp "$USER_HOME/.zshrc" "$USER_HOME/.zshrc_backup"
fi
[ -f .zshrc ] && cp .zshrc "$USER_HOME/"

# Permissions
chown -R "$TARGET_USER:$TARGET_USER" "$USER_HOME/.config" "$USER_HOME/.zshrc" "$USER_HOME/wallpaper.jpg" 2>/dev/null || true
chmod -R +x "$USER_HOME/.config/bspwm" "$USER_HOME/.config/sxhkd" 2>/dev/null || true
find "$USER_HOME/.config/polybar" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true

# Install yay for target user
if ! command -v yay >/dev/null 2>&1; then
    cd /tmp
    su - "$TARGET_USER" -c "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si --noconfirm" || true
    rm -rf /tmp/yay-bin
fi

# Install essential desktop applications
su - "$TARGET_USER" -c "yay -S --needed --noconfirm bspwm sxhkd polybar rofi picom feh alacritty thunar starship lightdm lightdm-gtk-greeter variety pacman-contrib wmctrl gtk3 gtk3-nocsd qt5-base qt5ct kvantum lxappearance neovim xclip fastfetch mpd pavucontrol wget zsh papirus-icon-theme ttf-font-awesome ttf-fira-code" || true

# Font cache refresh
fc-cache -f
echo "✓ Server BSPWM setup finished successfully."
