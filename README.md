# minimal-dots

Minimal NixOS dotfiles with a focus on Vim-like motions and efficiency.

## Summary

This configuration is designed for users who prefer keyboard-centric workflows. It supports both **Hyprland** (modern, dynamic) and **Sway** (stable, lightweight) as tiling window managers. It uses **Neovim** as the primary editor and **Fish** as the shell. Most navigation and system interactions follow the `hjkl` paradigm.

## Important Applications

- **Window Managers:** [Hyprland](https://hyprland.org/) or [Sway](https://swaywm.org/)
- **Terminal:** [Foot](https://codeberg.org/dnkl/foot)
- **Shell:** [Fish](https://fishshell.com/)
- **Editor:** [Neovim](https://neovim.io/) (Custom configuration)
- **Application Launcher:** [Wofi](https://hg.sr.ht/~scoopta/wofi) / [Rofi](https://github.com/davatorium/rofi)
- **Status Bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Notifications:** [Dunst](https://dunst-project.org/)
- **Wallpaper:** [Hyprpaper](https://github.com/hyprwm/hyprpaper) (Hyprland) / Native (Sway)
- **Screenshots:** [Grim](https://sr.ht/~emersion/grim/) & [Slurp](https://sr.ht/~emersion/slurp/)

## Key Bindings

The `SUPER` (Windows) key is the main modifier (`$mod`).

### System

- `SUPER + RETURN`: Open Terminal (Foot + Fish)
- `SUPER + Q`: Kill active window
- `SUPER + R`: Open Application Menu (Wofi)
- `SUPER + W`: Open Browser (Firefox)
- `SUPER + C`: Open Slack
- `SUPER + V`: Toggle Floating window
- `SUPER + D`: Toggle Fullscreen / Tabbed layout

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

1. Prompt you to choose between **Hyprland** and **Sway**.
2. Copy wallpapers to `~/Pictures`.
3. Install common configurations (`dunst`, `fish`, `foot`, `nvim`) to `~/.config/`.
4. Install the selected WM's specific configuration.
5. Setup **Waybar** for the selected environment.
6. Backup existing configurations with a `.bak` suffix.
7. Copy the appropriate NixOS configuration to `/etc/nixos` (requires `sudo`).

## Vim-like Motions

This setup emphasizes `hjkl` for navigation across the entire system:

- **Neovim:** Standard vim motions and custom mappings.
- **Window Manager:** Focus and window movement using `SUPER + hjkl`.
