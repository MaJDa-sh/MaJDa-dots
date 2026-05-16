# minimal-docs

Minimal NixOS dotfiles with a focus on Vim-like motions and efficiency.

## Summary

This configuration is designed for users who prefer keyboard-centric workflows. It uses **Hyprland** as the tiling window manager, **Neovim** as the primary editor, and **Fish** as the shell. Most navigation and system interactions follow the `hjkl` paradigm.

## Important Applications

- **Window Manager:** [Hyprland](https://hyprland.org/)
- **Terminal:** [Foot](https://codeberg.org/dnkl/foot)
- **Shell:** [Fish](https://fishshell.com/)
- **Editor:** [Neovim](https://neovim.io/) (NvChad based)
- **Application Launcher:** [Wofi](https://hg.sr.ht/~scoopta/wofi) / [Rofi](https://github.com/davatorium/rofi)
- **Status Bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Notifications:** [Dunst](https://dunst-project.org/)
- **Wallpaper:** [Hyprpaper](https://github.com/hyprwm/hyprpaper)
- **Screenshots:** [Grim](https://sr.ht/~emersion/grim/) & [Slurp](https://sr.ht/~emersion/slurp/)

## Key Bindings

The `SUPER` (Windows) key is the main modifier (`$mainMod`).

### System

- `SUPER + RETURN`: Open Terminal (Foot + Fish)
- `SUPER + Q`: Kill active window
- `SUPER + R`: Open Application Menu (Wofi)
- `SUPER + W`: Open Browser (Firefox)
- `SUPER + C`: Open Slack
- `SUPER + V`: Toggle Floating window
- `SUPER + D`: Toggle Fullscreen

### Navigation (Vim-like)

- `SUPER + H/J/K/L`: Move focus (Left/Down/Up/Right)
- `SUPER + SHIFT + H/J/K/L`: Move window position
- `SUPER + CTRL + H/L`: Switch workspace (Prev/Next)
- `SUPER + 1-0`: Switch to workspace 1-10
- `SUPER + SHIFT + 1-0`: Move window to workspace 1-10

### Screenshots

- `SUPER + S`: Select area and copy to clipboard
- `SUPER + SHIFT + S`: Capture full screen to `~/Pictures/screenshot-...`

## Installation

To install these dotfiles, run the provided installation script:

```bash
chmod +x install.sh
./install.sh
```

**Note:** The script will:

1. Copy wallpapers to `~/Pictures`.
2. Install configurations (`dunst`, `fish`, `foot`, `hypr`, `nvim`, `waybar`) to `~/.config/`.
3. Backup existing configurations with a `.bak` suffix.
4. Copy NixOS configuration to `/etc/nixos` (requires `sudo`).

## Vim-like Motions

This setup emphasizes `hjkl` for navigation across the entire system:

- **Neovim:** Standard vim motions and custom mappings.
- **Hyprland:** Focus and window movement using `SUPER + hjkl`.
