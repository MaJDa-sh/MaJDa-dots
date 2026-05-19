#!/usr/bin/env bash

# Colors for output
GREEN='\033[0-9;32m'
BLUE='\033[0-9;34m'
RED='\033[0-9;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting minimal-docs installation...${NC}"

# Ask for Window Manager choice
echo -e "${BLUE}Choose your Window Manager:${NC}"
echo "1) Hyprland (Modern, Blur, Animations)"
echo "2) Sway (Optimized, Stable, Low RAM)"
read -p "Enter choice [1-2]: " wm_choice

case $wm_choice in
    1)
        WM="hypr"
        echo -e "${GREEN}Hyprland selected.${NC}"
        ;;
    2)
        WM="sway"
        echo -e "${GREEN}Sway selected.${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice. Defaulting to Hyprland.${NC}"
        WM="hypr"
        ;;
esac

# Ensure directories exist
mkdir -p ~/Pictures
mkdir -p ~/.config

# Copy wallpapers
echo -e "${GREEN}Copying wallpapers to ~/Pictures...${NC}"
cp wallpaper.jpg ~/Pictures/
cp wallpaper2.jpg ~/Pictures/

# Copy common config folders
COMMON_FOLDERS=("dunst" "fish" "foot" "nvim")
for folder in "${COMMON_FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        echo -e "${GREEN}Installing common config: $folder...${NC}"
        if [ -d "$HOME/.config/$folder" ]; then
            echo -e "Backing up existing ~/.config/$folder"
            rm -rf "$HOME/.config/${folder}.bak"
            mv "$HOME/.config/$folder" "$HOME/.config/${folder}.bak"
        fi
        cp -r "$folder" ~/.config/
    fi
done

# Install selected WM config
if [ -d "$WM" ]; then
    echo -e "${GREEN}Installing $WM configuration...${NC}"
    if [ -d "$HOME/.config/$WM" ]; then
        rm -rf "$HOME/.config/${WM}.bak"
        mv "$HOME/.config/$WM" "$HOME/.config/${WM}.bak"
    fi
    cp -r "$WM" ~/.config/
fi

# Special handling for Waybar
mkdir -p ~/.config/waybar
if [ -d "$HOME/.config/waybar" ]; then
    cp waybar/style.css ~/.config/waybar/
    cp "waybar/config.$WM" ~/.config/waybar/config
    echo -e "${GREEN}Installed Waybar configuration for $WM.${NC}"
fi

# Copy nixos config to /etc/nixos (requires sudo)
if [ -d "nixos" ]; then
    echo -e "${BLUE}Requesting sudo to install NixOS configuration to /etc/nixos...${NC}"
    if [ -d "/etc/nixos" ]; then
        echo -e "Backing up existing /etc/nixos to /etc/nixos.bak"
        sudo rm -rf /etc/nixos.bak
        sudo cp -r /etc/nixos /etc/nixos.bak
    fi
    sudo mkdir -p /etc/nixos
    sudo cp nixos/hardware-configuration.nix /etc/nixos/
    sudo cp "nixos/configuration.$WM.nix" /etc/nixos/configuration.nix
    echo -e "${GREEN}Installed NixOS configuration for $WM.${NC}"
else
    echo -e "${RED}Warning: nixos directory not found!${NC}"
fi

echo -e "${BLUE}Installation complete! Please restart your session or reload configs.${NC}"
