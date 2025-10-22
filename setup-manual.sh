#!/bin/bash

# ╔═══════════════════════════════════════════════════════════╗
# ║  CYBERPUNK HYPRLAND MANUAL SETUP SCRIPT V3               ║
# ║  For users who want more control over installation       ║
# ╚═══════════════════════════════════════════════════════════╝

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${MAGENTA}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║          CYBERPUNK HYPRLAND - MANUAL INSTALLER            ║
║                   Version 3.0 (Manual)                    ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}This is the MANUAL installation script.${NC}"
echo "You'll be prompted for each step and can skip what you don't need."
echo ""

# ============================================================
# SAFETY CHECKS
# ============================================================

if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}❌ Don't run this script as root!${NC}"
    exit 1
fi

if [ ! -f /etc/arch-release ]; then
    echo -e "${YELLOW}⚠️  This script is designed for Arch Linux${NC}"
    read -p "Continue anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# ============================================================
# STEP 1: UPDATE SYSTEM
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 1: System Update${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p "Update system? (recommended) [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -Syu --noconfirm
    echo -e "${GREEN}✓${NC} System updated"
else
    echo -e "${YELLOW}⊘${NC} Skipped system update"
fi

# ============================================================
# STEP 2: INSTALL CORE PACKAGES
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 2: Core Packages${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Core: hyprland kitty nemo wofi waybar xdg-desktop-portal-hyprland"
read -p "Install core packages? [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        hyprland kitty nemo wofi waybar \
        xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
        qt5-wayland qt6-wayland
    echo -e "${GREEN}✓${NC} Core packages installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped core packages"
fi

# ============================================================
# STEP 3: WALLPAPER DAEMON
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 3: Wallpaper Daemon${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "swww - supports static images, GIFs, and videos"
read -p "Install swww? (recommended) [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -S --needed --noconfirm swww
    echo -e "${GREEN}✓${NC} swww installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped swww"
fi

# ============================================================
# STEP 4: FONTS
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 4: Fonts${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "JetBrains Mono Nerd Font, Font Awesome, Noto fonts"
read -p "Install fonts? (required for icons) [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        ttf-jetbrains-mono-nerd ttf-font-awesome \
        noto-fonts noto-fonts-emoji
    echo -e "${GREEN}✓${NC} Fonts installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped fonts"
fi

# ============================================================
# STEP 5: SCREENSHOT TOOLS
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 5: Screenshot & Clipboard${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "grim, slurp, wl-clipboard, cliphist"
read -p "Install screenshot tools? [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        grim slurp wl-clipboard cliphist
    echo -e "${GREEN}✓${NC} Screenshot tools installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped screenshot tools"
fi

# ============================================================
# STEP 6: AUDIO SYSTEM
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 6: Audio System${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "PipeWire, WirePlumber, PulseAudio compatibility, pavucontrol"
read -p "Install audio system? [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        pipewire wireplumber pipewire-pulse \
        pipewire-alsa pipewire-jack pavucontrol
    echo -e "${GREEN}✓${NC} Audio system installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped audio system"
fi

# ============================================================
# STEP 7: SYSTEM UTILITIES
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 7: System Utilities${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "brightnessctl, playerctl, NetworkManager, polkit, mako"
read -p "Install system utilities? [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        brightnessctl playerctl networkmanager \
        nm-connection-editor network-manager-applet \
        polkit-gnome mako papirus-icon-theme xdg-utils
    echo -e "${GREEN}✓${NC} System utilities installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped system utilities"
fi

# ============================================================
# STEP 8: LOGIN MANAGER
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 8: Login Manager${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Choose:"
echo "  1) ly (minimal TUI)"
echo "  2) SDDM (graphical)"
echo "  3) None (skip)"
read -p "Choice [1/2/3]: " -n 1 -r
echo

case $REPLY in
    1)
        echo "Installing ly (requires AUR helper)..."
        if command -v yay &> /dev/null; then
            yay -S --needed --noconfirm ly
            echo -e "${GREEN}✓${NC} ly installed"
        elif command -v paru &> /dev/null; then
            paru -S --needed --noconfirm ly
            echo -e "${GREEN}✓${NC} ly installed"
        else
            echo -e "${YELLOW}⚠️  No AUR helper found. Install yay first?${NC}"
            read -p "[Y/n]: " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                sudo pacman -S --needed --noconfirm base-devel git
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                yay -S --needed --noconfirm ly
                echo -e "${GREEN}✓${NC} ly installed"
            else
                echo -e "${YELLOW}⊘${NC} Skipped ly - install manually"
            fi
        fi
        LOGIN_MANAGER="ly"
        ;;
    2)
        sudo pacman -S --needed --noconfirm sddm
        echo -e "${GREEN}✓${NC} SDDM installed"
        LOGIN_MANAGER="sddm"
        ;;
    *)
        echo -e "${YELLOW}⊘${NC} Skipped login manager"
        LOGIN_MANAGER="none"
        ;;
esac

# ============================================================
# STEP 9: OPTIONAL PACKAGES
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 9: Optional Packages${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "swaylock, swayidle, Bluetooth, theme tools"
read -p "Install optional packages? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        swaylock swayidle bluez bluez-utils blueman nwg-look
    echo -e "${GREEN}✓${NC} Optional packages installed"
else
    echo -e "${YELLOW}⊘${NC} Skipped optional packages"
fi

# ============================================================
# STEP 10: CREATE DIRECTORIES
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 10: Create Directories${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p "Create config directories? [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    mkdir -p ~/.config/{hypr,waybar,wofi,kitty,mako,gtk-3.0,gtk-4.0}
    mkdir -p ~/Pictures/{Wallpapers,Screenshots}
    echo -e "${GREEN}✓${NC} Directories created"
else
    echo -e "${YELLOW}⊘${NC} Skipped directory creation"
fi

# ============================================================
# STEP 11: COPY CONFIG FILES
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 11: Copy Configuration Files${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$SCRIPT_DIR/configs" ]; then
    echo "Found configs directory in repo"
    read -p "Copy all config files? [Y/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        cp -f "$SCRIPT_DIR/configs/hypr/hyprland.conf" ~/.config/hypr/ 2>/dev/null && echo -e "${GREEN}✓${NC} Hyprland config" || echo -e "${YELLOW}⊘${NC} Hyprland config not found"
        cp -f "$SCRIPT_DIR/configs/waybar/config" ~/.config/waybar/ 2>/dev/null && echo -e "${GREEN}✓${NC} Waybar config" || echo -e "${YELLOW}⊘${NC} Waybar config not found"
        cp -f "$SCRIPT_DIR/configs/waybar/style.css" ~/.config/waybar/ 2>/dev/null && echo -e "${GREEN}✓${NC} Waybar style" || echo -e "${YELLOW}⊘${NC} Waybar style not found"
        cp -f "$SCRIPT_DIR/configs/wofi/config" ~/.config/wofi/ 2>/dev/null && echo -e "${GREEN}✓${NC} Wofi config" || echo -e "${YELLOW}⊘${NC} Wofi config not found"
        cp -f "$SCRIPT_DIR/configs/wofi/style.css" ~/.config/wofi/ 2>/dev/null && echo -e "${GREEN}✓${NC} Wofi style" || echo -e "${YELLOW}⊘${NC} Wofi style not found"
        cp -f "$SCRIPT_DIR/configs/kitty/kitty.conf" ~/.config/kitty/ 2>/dev/null && echo -e "${GREEN}✓${NC} Kitty config" || echo -e "${YELLOW}⊘${NC} Kitty config not found"
        cp -f "$SCRIPT_DIR/configs/mako/config" ~/.config/mako/ 2>/dev/null && echo -e "${GREEN}✓${NC} Mako config" || echo -e "${YELLOW}⊘${NC} Mako config not found"
        cp -f "$SCRIPT_DIR/configs/gtk/gtk-3.0/settings.ini" ~/.config/gtk-3.0/ 2>/dev/null && echo -e "${GREEN}✓${NC} GTK3 settings" || echo -e "${YELLOW}⊘${NC} GTK3 settings not found"
        cp -f "$SCRIPT_DIR/configs/gtk/gtk-3.0/gtk.css" ~/.config/gtk-3.0/ 2>/dev/null && echo -e "${GREEN}✓${NC} GTK3 CSS" || echo -e "${YELLOW}⊘${NC} GTK3 CSS not found"
        cp -f "$SCRIPT_DIR/configs/gtk/gtk-4.0/settings.ini" ~/.config/gtk-4.0/ 2>/dev/null && echo -e "${GREEN}✓${NC} GTK4 settings" || echo -e "${YELLOW}⊘${NC} GTK4 settings not found"
    fi
else
    echo -e "${YELLOW}⚠️  No configs directory found${NC}"
    echo "You'll need to copy config files manually to:"
    echo "  ~/.config/hypr/hyprland.conf"
    echo "  ~/.config/waybar/{config,style.css}"
    echo "  ~/.config/wofi/{config,style.css}"
    echo "  ~/.config/kitty/kitty.conf"
    echo "  ~/.config/mako/config"
    echo "  ~/.config/gtk-3.0/{settings.ini,gtk.css}"
    echo "  ~/.config/gtk-4.0/settings.ini"
fi

# ============================================================
# STEP 12: WALLPAPER SETUP
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 12: Wallpaper Setup${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ -d "$SCRIPT_DIR/wallpapers" ] && [ "$(ls -A $SCRIPT_DIR/wallpapers)" ]; then
    echo "Found wallpapers in repo"
    read -p "Copy wallpapers? [Y/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        cp -f "$SCRIPT_DIR/wallpapers/"* ~/Pictures/Wallpapers/ 2>/dev/null
        echo -e "${GREEN}✓${NC} Wallpapers copied"
    fi
else
    echo -e "${YELLOW}ℹ${NC}  Add wallpapers to ~/Pictures/Wallpapers/"
fi

echo ""
echo "Update wallpaper path in ~/.config/hypr/hyprland.conf"
echo "Line: exec-once = swww img ~/Pictures/Wallpapers/YOUR_WALLPAPER.jpg"

# ============================================================
# STEP 13: ENABLE SERVICES
# ============================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 13: Enable Services${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

read -p "Enable NetworkManager? [Y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    sudo systemctl enable --now NetworkManager
    echo -e "${GREEN}✓${NC} NetworkManager enabled"
fi

if [ "$LOGIN_MANAGER" = "ly" ]; then
    read -p "Enable ly login manager? [Y/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        sudo systemctl enable ly.service
        echo -e "${GREEN}✓${NC} ly enabled"
    fi
elif [ "$LOGIN_MANAGER" = "sddm" ]; then
    read -p "Enable SDDM login manager? [Y/n]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        sudo systemctl enable sddm.service
        echo -e "${GREEN}✓${NC} SDDM enabled"
    fi
fi

if systemctl list-unit-files | grep -q bluetooth.service; then
    read -p "Enable Bluetooth? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl enable --now bluetooth
        echo -e "${GREEN}✓${NC} Bluetooth enabled"
    fi
fi

# ============================================================
# COMPLETION
# ============================================================

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅  Manual Installation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo "  1. Review configs in ~/.config/"
echo "  2. Add wallpaper to ~/Pictures/Wallpapers/"
echo "  3. Update wallpaper path in hyprland.conf"
echo "  4. Reboot: ${YELLOW}sudo reboot${NC}"
echo "  5. Select Hyprland from login manager"
echo ""
echo -e "${MAGENTA}Enjoy your Cyberpunk desktop! 🌆⚡${NC}"
echo ""
