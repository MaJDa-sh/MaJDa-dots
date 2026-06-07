# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = config.nixpkgs.config;
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.grub.efiSupport = true;

  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.devices = [ "nodev" ];

  nixpkgs.config.allowUnfree = true; 

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  programs.nix-ld.enable = true;

  nix.settings.trusted-users = [ "root" "kacper" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
  ];

  powerManagement.cpuFreqGovernor = "performance";

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.displayManager.sddm.enable = false;
  services.displayManager.ly.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.fish.enable = true;

  # Define a user account.
  users.users.kacper = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkManager" "video" "audio" ];
    packages = with pkgs; [
      tree
    ];
  };

fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
};

  programs.sway.enable = true;

  # List packages installed in system profile.
   environment.systemPackages = with pkgs; [
     vim
     wget

     sway
     swaybg
     waybar
     kitty
     rofi
     
     firefox
     git
     wget
     
     grim
     slurp
     wl-clipboard
     brightnessctl
     playerctl
     dunst
     pavucontrol
     networkmanagerapplet

     nerd-fonts.jetbrains-mono

     fish
     foot

     bibata-cursors
     htop
     lazygit
     unstable.neovim

     asdf-vm

     slack
     unstable.devenv
     fastfetch
     fzf

     claude-code

     qwen-code
     signal-desktop

     unstable.gemini-cli

     python315
   ];

  system.stateVersion = "25.11"; 

}
