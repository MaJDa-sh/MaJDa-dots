#!/usr/bin/env bash

# Colors for output
GREEN='\033[0-9;32m'
BLUE='\033[0-9;34m'
RED='\033[0-9;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting minimal-docs installation...${NC}"

# Ensure directories exist
mkdir -p ~/Pictures
mkdir -p ~/.config

# Copy wallpapers
echo -e "${GREEN}Copying wallpapers to ~/Pictures...${NC}"
cp wallpaper.jpg ~/Pictures/
cp wallpaper2.jpg ~/Pictures/

# Copy config folders to ~/.config
CONFIG_FOLDERS=("dunst" "fish" "foot" "hypr" "nvim" "waybar")
for folder in "${CONFIG_FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        echo -e "${GREEN}Installing $folder to ~/.config/$folder...${NC}"
        # Backup existing config if it exists
        if [ -d "$HOME/.config/$folder" ]; then
            echo -e "Backing up existing ~/.config/$folder to ~/.config/${folder}.bak"
            rm -rf "$HOME/.config/${folder}.bak"
            mv "$HOME/.config/$folder" "$HOME/.config/${folder}.bak"
        fi
        cp -r "$folder" ~/.config/
    else
        echo -e "${RED}Warning: $folder directory not found!${NC}"
    fi
done

# Copy nixos config to /etc/nixos (requires sudo)
if [ -d "nixos" ]; then
    echo -e "${BLUE}Requesting sudo to install NixOS configuration to /etc/nixos...${NC}"
    if [ -d "/etc/nixos" ]; then
        echo -e "Backing up existing /etc/nixos to /etc/nixos.bak"
        sudo rm -rf /etc/nixos.bak
        sudo mv /etc/nixos /etc/nixos.bak
    fi
    sudo cp -r nixos /etc/nixos
else
    echo -e "${RED}Warning: nixos directory not found!${NC}"
fi

echo -e "${BLUE}Installation complete! Please restart your session or reload configs.${NC}"
