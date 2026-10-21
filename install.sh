#!/bin/bash
set -eo pipefail

# Arch Linux BSPWM rice installer
echo "=================================================="
echo "          Arch Linux BSPWM Rice Installer         "
echo "=================================================="

# Enable parallel downloads in pacman
sudo sed -i 's/^#ParallelDownloads = [0-9]\+/ParallelDownloads = 5/' /etc/pacman.conf

echo "Updating system packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel xorg xorg-server reflector rsync curl xorg-xinit unzip xorg-xrandr xorg-xsetroot dbus

# Optimize mirrors based on country
con=$(curl -4s https://ifconfig.co/country-iso 2>/dev/null || echo "")
if [ -n "$con" ]; then
    echo "Configuring mirrors for country: $con"
    sudo reflector --verbose -c "$con" -l 5 --sort rate --save /etc/pacman.d/mirrorlist || true
fi

# Create target directories safely
mkdir -p "$HOME"/.config/{bspwm,sxhkd,polybar,rofi,alacritty}

# Copy wallpaper
if [ -f wallpaper.jpg ]; then
    cp wallpaper.jpg "$HOME/wallpaper.jpg"
fi

# Apply dotfiles safely
[ -d bspwm ] && cp -r bspwm/* "$HOME/.config/bspwm/"
[ -d sxhkd ] && cp -r sxhkd/* "$HOME/.config/sxhkd/"
[ -d polybar ] && cp -r polybar/* "$HOME/.config/polybar/"
[ -d rofi ] && cp -r rofi/* "$HOME/.config/rofi/"
[ -d alacritty ] && cp -r alacritty/* "$HOME/.config/alacritty/"

if [ -d fonts ]; then
    sudo mkdir -p /usr/share/fonts/local-fonts
    sudo cp -r fonts/* /usr/share/fonts/local-fonts/
fi

# Backup existing zshrc if present
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc_backup_$(date +%s)"
fi
[ -f .zshrc ] && cp .zshrc "$HOME/.zshrc"

# Permissions
chmod -R +x "$HOME/.config/bspwm" "$HOME/.config/sxhkd" 2>/dev/null || true
find "$HOME/.config/polybar" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true

# Install yay if neither yay nor paru is installed
if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
    echo "Installing yay AUR helper..."
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$TEMP_DIR/yay-bin"
    (cd "$TEMP_DIR/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$TEMP_DIR"
fi

AUR_HELPER="yay"
if command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
fi

echo "Installing Desktop Environment packages with $AUR_HELPER..."
$AUR_HELPER -S --needed --noconfirm bspwm sxhkd polybar rofi picom feh alacritty thunar \
    starship lightdm lightdm-gtk-greeter variety pacman-contrib wmctrl \
    gtk3 gtk3-nocsd qt5-base qt5ct kvantum lxappearance neovim xclip fastfetch \
    mpd pavucontrol wget zsh papirus-icon-theme ttf-font-awesome ttf-fira-code || true

# Setup virtualization stack
echo "Setting up KVM / QEMU..."
sudo pacman -S --needed --noconfirm qemu-desktop virt-manager virt-viewer dnsmasq bridge-utils iptables libguestfs edk2-ovmf || true
sudo systemctl enable --now libvirtd.service || true
sudo usermod -aG libvirt "$USER"

# Reload font cache
echo "Reloading font cache..."
fc-cache -f

echo "=================================================="
echo "✓ Arch BSPWM setup complete! Reboot to start your rice."
echo "=================================================="
