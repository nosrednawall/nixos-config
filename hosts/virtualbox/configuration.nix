{ config, pkgs, lib, ... }:

{

  fonts.enableDefaultPackages = true;
  imports = [
    ./hardware-configuration.nix
    ../../modules/suckless.nix
    ../../modules/audio.nix
    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/fonts.nix
    ../../modules/packages.nix
  ];

  # Hostname
  networking.hostName = "virtualbox";

  # Bootloader — GRUB with EFI and os-prober for Windows dual-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = false;
      useOSProber = true;
    };
  };

  # Dual-boot clock compatibility (Windows uses localtime)
  time.hardwareClockInLocalTime = true;

  # Blacklist NVIDIA — Intel iGPU only
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Zsh system-wide
  programs.zsh.enable = true;

  # User account
  users.users.anderson = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "bluetooth" ];
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.anderson = import ../../home;
  };

  system.stateVersion = "25.05";
}
