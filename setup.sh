#!/bin/bash

# ╔═══════════════════════════════════════════════════════════╗
# ║  CYBERPUNK HYPRLAND SETUP SCRIPT V3                      ║
# ║  Fully Automated - Zero Manual Intervention              ║
# ║  For use with GitHub repository structure                ║
# ╚═══════════════════════════════════════════════════════════╝

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Cyberpunk banner
echo -e "${MAGENTA}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║   ██████╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗ ██╗   ██╗███╗   ██╗██╗  ██╗
║  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗██║   ██║████╗  ██║██║ ██╔╝
║  ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║█████╔╝ 
║  ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔═══╝ ██║   ██║██║╚██╗██║██╔═██╗ 
║  ╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║     ╚██████╔╝██║ ╚████║██║  ██╗
║   ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝
║                                                            ║
║             HYPRLAND DYSTOPIA THEME INSTALLER             ║
║                      Version 3.0                          ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

sleep 1

# ============================================================
# CHECKS
# ============================================================

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}❌ Don't run this script as root!${NC}"
    echo "Run as normal user. Script will ask for sudo when needed."
    exit 1
fi

# Check if on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo -e "${RED}❌ This script is designed for Arch Linux!${NC}"
    echo "Other distros require different package names."
    exit 1
fi

# Check if script is in repo directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -d "$SCRIPT_DIR/configs" ]; then
    echo -e "${RED}❌ Config directory not found!${NC}"
    echo "Make sure you're running this from the cloned repository:"
    echo "  git clone https://github.com/Expert21/cyberpunk-hyprland"
    echo "  cd cyberpunk-hyprland"
    echo "  chmod +x setup.sh"
    echo "  ./setup.sh"
    exit 1
fi

echo -e "${GREEN}✓${NC} Running from: $SCRIPT_DIR"
echo ""

# ============================================================
# WELCOME & WARNINGS
# ============================================================

echo -e "${CYAN}This script will:${NC}"
echo "  • Install all required packages"
echo "  • Copy configuration files"
echo "  • Set up login manager"
echo "  • Configure system services"
echo "  • Create necessary directories"
echo ""
echo -e "${YELLOW}⚠️  Warning:${NC}"
echo "  • Designed for FRESH Arch install"
echo "  • May conflict with existing DEs"
echo "  • Will modify system files"
echo ""

read -p "Continue? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""

# ============================================================
# CHOOSE LOGIN MANAGER
# ============================================================

echo -e "${CYAN}Choose your login manager:${NC}"
echo "  1) ly (minimal, terminal-based) [recommended]"
echo "  2) SDDM (graphical, themeable)"
echo ""
read -p "Enter choice [1-2] (default: 1): " LOGIN_CHOICE

case $LOGIN_CHOICE in
    2)
        LOGIN_MANAGER="sddm"
        echo -e "${GREEN}✓${NC} Selected: SDDM"
        ;;
    *)
        LOGIN_MANAGER="ly"
        echo -e "${GREEN}✓${NC} Selected: ly"
        ;;
esac

echo ""

# ============================================================
# UPDATE SYSTEM
# ============================================================

echo -e "${CYAN}📦 Updating system...${NC}"
sudo pacman -Syu --noconfirm
echo -e "${GREEN}✓${NC} System updated"
echo ""

# ============================================================
# INSTALL PACKAGES
# ============================================================

echo -e "${CYAN}📦 Installing core packages...${NC}"
echo "This may take several minutes..."
echo ""

# Core Hyprland packages
sudo pacman -S --needed --noconfirm \
    hyprland \
    kitty \
    nemo \
    wofi \
    waybar \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt5-wayland \
    qt6-wayland

echo -e "${GREEN}✓${NC} Hyprland packages installed"

# Wallpaper and visual tools
sudo pacman -S --needed --noconfirm \
    swww

echo -e "${GREEN}✓${NC} Wallpaper daemon installed"

# Fonts
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji

echo -e "${GREEN}✓${NC} Fonts installed"

# Screenshot and clipboard
sudo pacman -S --needed --noconfirm \
    grim \
    slurp \
    wl-clipboard \
    cliphist

echo -e "${GREEN}✓${NC} Screenshot tools installed"

# Audio
sudo pacman -S --needed --noconfirm \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
    pavucontrol

echo -e "${GREEN}✓${NC} Audio system installed"

# System utilities
sudo pacman -S --needed --noconfirm \
    brightnessctl \
    playerctl \
    networkmanager \
    nm-connection-editor \
    network-manager-applet \
    polkit-gnome \
    mako \
    papirus-icon-theme \
    xdg-utils

echo -e "${GREEN}✓${NC} System utilities installed"

# Login manager
if [ "$LOGIN_MANAGER" = "ly" ]; then
    # ly is in AUR, check if yay/paru available
    if command -v yay &> /dev/null; then
        yay -S --needed --noconfirm ly
    elif command -v paru &> /dev/null; then
        paru -S --needed --noconfirm ly
    else
        echo -e "${YELLOW}⚠️  Installing yay for AUR support...${NC}"
        sudo pacman -S --needed --noconfirm base-devel git
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        yay -S --needed --noconfirm ly
    fi
    echo -e "${GREEN}✓${NC} ly installed"
else
    sudo pacman -S --needed --noconfirm sddm
    echo -e "${GREEN}✓${NC} SDDM installed"
fi

# Optional packages prompt
echo ""
read -p "Install optional packages? (bluetooth, screen lock) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        swaylock \
        swayidle \
        bluez \
        bluez-utils \
        blueman \
        nwg-look
    echo -e "${GREEN}✓${NC} Optional packages installed"
fi

echo ""

# ============================================================
# CREATE DIRECTORIES
# ============================================================

echo -e "${CYAN}📁 Creating directories...${NC}"

mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/wofi
mkdir -p ~/.config/kitty
mkdir -p ~/.config/mako
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/Pictures/Screenshots

echo -e "${GREEN}✓${NC} Directories created"
echo ""

# ============================================================
# COPY CONFIG FILES
# ============================================================

echo -e "${CYAN}📝 Copying configuration files...${NC}"

# Hyprland
cp -f "$SCRIPT_DIR/configs/hypr/hyprland.conf" ~/.config/hypr/hyprland.conf
echo -e "${GREEN}✓${NC} Hyprland config"

# Waybar
cp -f "$SCRIPT_DIR/configs/waybar/config" ~/.config/waybar/config
cp -f "$SCRIPT_DIR/configs/waybar/style.css" ~/.config/waybar/style.css
echo -e "${GREEN}✓${NC} Waybar config"

# Wofi
cp -f "$SCRIPT_DIR/configs/wofi/config" ~/.config/wofi/config
cp -f "$SCRIPT_DIR/configs/wofi/style.css" ~/.config/wofi/style.css
echo -e "${GREEN}✓${NC} Wofi config"

# Kitty
cp -f "$SCRIPT_DIR/configs/kitty/kitty.conf" ~/.config/kitty/kitty.conf
echo -e "${GREEN}✓${NC} Kitty config"

# Mako
cp -f "$SCRIPT_DIR/configs/mako/config" ~/.config/mako/config
echo -e "${GREEN}✓${NC} Mako config"

# GTK
cp -f "$SCRIPT_DIR/configs/gtk/gtk-3.0/settings.ini" ~/.config/gtk-3.0/settings.ini
cp -f "$SCRIPT_DIR/configs/gtk/gtk-3.0/gtk.css" ~/.config/gtk-3.0/gtk.css
cp -f "$SCRIPT_DIR/configs/gtk/gtk-4.0/settings.ini" ~/.config/gtk-4.0/settings.ini
echo -e "${GREEN}✓${NC} GTK config"

echo ""

# ============================================================
# WALLPAPER SETUP
# ============================================================

echo -e "${CYAN}🖼️  Setting up wallpaper...${NC}"

# Check if wallpapers directory in repo has files
if [ -d "$SCRIPT_DIR/wallpapers" ] && [ "$(ls -A $SCRIPT_DIR/wallpapers)" ]; then
    cp -f "$SCRIPT_DIR/wallpapers/"* ~/Pictures/Wallpapers/
    FIRST_WALLPAPER=$(ls ~/Pictures/Wallpapers/ | head -n 1)
    
    # Update hyprland.conf with wallpaper path
    sed -i "s|exec-once = swww img.*|exec-once = swww img ~/Pictures/Wallpapers/$FIRST_WALLPAPER --transition-type grow --transition-fps 60|" ~/.config/hypr/hyprland.conf
    
    echo -e "${GREEN}✓${NC} Wallpaper copied and configured"
else
    echo -e "${YELLOW}⚠️  No wallpapers found in repo${NC}"
    echo "Add wallpapers to ~/Pictures/Wallpapers/ and update:"
    echo "  ~/.config/hypr/hyprland.conf (line: exec-once = swww img ...)"
fi

echo ""

# ============================================================
# ENABLE SERVICES
# ============================================================

echo -e "${CYAN}🔧 Enabling system services...${NC}"

# NetworkManager
sudo systemctl enable --now NetworkManager
echo -e "${GREEN}✓${NC} NetworkManager enabled"

# Login manager
if [ "$LOGIN_MANAGER" = "ly" ]; then
    sudo systemctl enable ly.service
    echo -e "${GREEN}✓${NC} ly enabled"
else
    sudo systemctl enable sddm.service
    echo -e "${GREEN}✓${NC} SDDM enabled"
fi

# Bluetooth (if installed)
if systemctl list-unit-files | grep -q bluetooth.service; then
    read -p "Enable Bluetooth? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl enable --now bluetooth
        echo -e "${GREEN}✓${NC} Bluetooth enabled"
    fi
fi

echo ""

# ============================================================
# POLKIT AUTHENTICATION AGENT
# ============================================================

echo -e "${CYAN}🔐 Configuring authentication...${NC}"

# Verify polkit agent is in hyprland.conf
if grep -q "polkit-gnome-authentication-agent" ~/.config/hypr/hyprland.conf; then
    echo -e "${GREEN}✓${NC} Polkit agent configured"
else
    echo -e "${YELLOW}⚠️  Polkit agent not found in config${NC}"
fi

echo ""

# ============================================================
# SET DEFAULT APPLICATIONS
# ============================================================

echo -e "${CYAN}🔧 Setting default applications...${NC}"

xdg-mime default nemo.desktop inode/directory
xdg-mime default kitty.desktop application/x-terminal-emulator

echo -e "${GREEN}✓${NC} Default apps configured"
echo ""

# ============================================================
# FINAL CHECKS
# ============================================================

echo -e "${CYAN}🔍 Running final checks...${NC}"

# Check if Hyprland binary exists
if command -v Hyprland &> /dev/null; then
    echo -e "${GREEN}✓${NC} Hyprland binary found"
else
    echo -e "${RED}❌ Hyprland binary not found!${NC}"
fi

# Check if configs exist
if [ -f ~/.config/hypr/hyprland.conf ]; then
    echo -e "${GREEN}✓${NC} Hyprland config exists"
else
    echo -e "${RED}❌ Hyprland config missing!${NC}"
fi

echo ""

# ============================================================
# COMPLETION
# ============================================================

echo -e "${MAGENTA}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║              ✅  INSTALLATION COMPLETE!  ✅                ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${GREEN}Your Cyberpunk Hyprland desktop is ready! 🌆⚡${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Reboot your system: ${YELLOW}sudo reboot${NC}"
echo "  2. Select 'Hyprland' from login manager"
echo "  3. Enjoy your cyberpunk dystopia! 🎮"
echo ""
echo -e "${CYAN}Keybinds reminder:${NC}"
echo "  • ${YELLOW}SUPER + Return${NC}     → Open terminal"
echo "  • ${YELLOW}SUPER + R${NC}          → App launcher"
echo "  • ${YELLOW}SUPER + Q${NC}          → Close window"
echo "  • ${YELLOW}SUPER + 1-9${NC}        → Switch workspace"
echo "  • ${YELLOW}SUPER + E${NC}          → File manager"
echo "  • ${YELLOW}SUPER + C${NC}          → Clipboard history"
echo "  • ${YELLOW}Print${NC}              → Screenshot"
echo ""
echo -e "${CYAN}Customization:${NC}"
echo "  • Configs: ${YELLOW}~/.config/hypr/${NC}"
echo "  • Wallpapers: ${YELLOW}~/Pictures/Wallpapers/${NC}"
echo "  • Waybar: ${YELLOW}~/.config/waybar/${NC}"
echo ""
echo -e "${MAGENTA}Enjoy the neon glow! ⚡🌃${NC}"
echo ""

# ============================================================
# REBOOT PROMPT
# ============================================================

read -p "Reboot now? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}Rebooting in 3 seconds...${NC}"
    sleep 3
    sudo reboot
else
    echo "Remember to reboot before using Hyprland!"
    echo "Run: ${YELLOW}sudo reboot${NC}"
fi`
